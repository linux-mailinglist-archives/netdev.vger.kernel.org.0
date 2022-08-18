Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D475980F8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242843AbiHRJkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242846AbiHRJkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:40:41 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305D6AFAE0
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 02:40:39 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r4so1157866edi.8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 02:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=LtnK31QB3QVkTuTql38qFHO91lItrzujcNass67Ka0c=;
        b=KCG+4l1P5gwEz+h78Tmx66b1+S8HYX62XY+SekE3wTM4ihglYwKAgqN01vwYFE7FBm
         H+dPIrGYlaDaAM34C+WFJTROik9Z3AwNOw7F4l6yO1LLz9b0AQT29R4B1ulY+LnnYBLI
         rNqG9i/gFsgHX9SKw2w6p115IZTApMQpvlXIFd/nVQfBUyMjgd5v/+dbK+i2vkArtYyg
         8uObD3gAZcSfmOz644UhGMZohg6bQWOoAFsuZGwr46s0+qXSYzikD/zCzEZKkqZ/jXXE
         NzLXWprGol49QSR8AH655cE+8u9YQKVG4VZerIu+o6Nvbchaxj161C60x7Ff1jgdY3Gd
         DATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=LtnK31QB3QVkTuTql38qFHO91lItrzujcNass67Ka0c=;
        b=N4/RS7+0VJmAh1jc4nwxzrHFYPi9kB2vEYEjEQ8nX4JwSRK8Dkdra5QrfP7SUirTs4
         HOG+HMRd//xjdAU+dOl28f2HmulDDbzNs6OV3xu3Hap+FkaC93nny0rL7B5Ql2KPM3a/
         YC8xD+OMPUi+DAU7W8SjbVMEc3F9qA8tOqKdWwatUsFhvubApwxM4pqybc8uqJgE6f+8
         m1jJN6OWqAypvbsYSCtqle9YX2x5vs9wzwKwypoqq590MOcpSXenM8hLZMMBuwGZnEPm
         gZYD1aQfLNyRECt+wb8Kjhl/pA1pFrfVLD+Qu7mOsFxMgq0QDoJ+2dua8H0/hCkRBI76
         3y6w==
X-Gm-Message-State: ACgBeo1nlwYH1jU2SF4xjbD/MQux2aLntBRb85Qu5TShhpplsgySWO3e
        xXPBJIMd3J1RKkk0wUSk/zAdhnslVDhhqFEm
X-Google-Smtp-Source: AA6agR5bzGhU11IIBl5qjWO0WBepjQZADYCxvRFy3mz4m/nmrbePphE61zPe5vq52EzHqSfbmftbLQ==
X-Received: by 2002:a05:6402:20b:b0:440:cb9f:c469 with SMTP id t11-20020a056402020b00b00440cb9fc469mr1655137edv.420.1660815637558;
        Thu, 18 Aug 2022 02:40:37 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090694c500b00734bfab4d59sm585392ejy.170.2022.08.18.02.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 02:40:37 -0700 (PDT)
Date:   Thu, 18 Aug 2022 11:40:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, moshe@nvidia.com,
        jacob.e.keller@intel.com
Subject: Re: [patch iproute2-main] devlink: load port-ifname map on demand
Message-ID: <Yv4JFNvAQ7jCyLlw@nanopsycho>
References: <20220818082856.413480-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818082856.413480-1-jiri@resnulli.us>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually, please scratch this for now. Depends on Jacob's "devlink:
remove dl_argv_parse_put" patch. Somehow I got the impression it is
already merged.

Sorry for the fuzz.


Thu, Aug 18, 2022 at 10:28:56AM CEST, jiri@resnulli.us wrote:
>From: Jiri Pirko <jiri@nvidia.com>
>
>So far, the port-ifname map was loaded during devlink init
>no matter if actually needed or not. Port dump cmd which is utilized
>for this in kernel takes lock for every devlink instance.
>That may lead to unnecessary blockage of command.
>
>Load the map only in time it is needed to lookup ifname.
>
>Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>---
> devlink/devlink.c | 31 ++++++++++++++++++-------------
> 1 file changed, 18 insertions(+), 13 deletions(-)
>
>diff --git a/devlink/devlink.c b/devlink/devlink.c
>index 21f26246f91b..4ef5dc4a5600 100644
>--- a/devlink/devlink.c
>+++ b/devlink/devlink.c
>@@ -374,6 +374,7 @@ struct dl {
> 	bool verbose;
> 	bool stats;
> 	bool hex;
>+	bool map_loaded;
> 	struct {
> 		bool present;
> 		char *bus_name;
>@@ -816,13 +817,15 @@ static void ifname_map_fini(struct dl *dl)
> 	}
> }
> 
>-static int ifname_map_init(struct dl *dl)
>+static void ifname_map_init(struct dl *dl)
> {
>-	struct nlmsghdr *nlh;
>-	int err;
>-
> 	INIT_LIST_HEAD(&dl->ifname_map_list);
>+}
> 
>+static int ifname_map_load(struct dl *dl)
>+{
>+	struct nlmsghdr *nlh;
>+	int err;
> 
> 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET,
> 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
>@@ -840,7 +843,16 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
> 			     uint32_t *p_port_index)
> {
> 	struct ifname_map *ifname_map;
>+	int err;
> 
>+	if (!dl->map_loaded) {
>+		err = ifname_map_load(dl);
>+		if (err) {
>+			pr_err("Failed to create index map\n");
>+			return err;
>+		}
>+		dl->map_loaded = true;
>+	}
> 	list_for_each_entry(ifname_map, &dl->ifname_map_list, list) {
> 		if (strcmp(ifname, ifname_map->ifname) == 0) {
> 			*p_bus_name = ifname_map->bus_name;
>@@ -9528,17 +9540,10 @@ static int dl_init(struct dl *dl)
> 		return -errno;
> 	}
> 
>-	err = ifname_map_init(dl);
>-	if (err) {
>-		pr_err("Failed to create index map\n");
>-		goto err_ifname_map_create;
>-	}
>+	ifname_map_init(dl);
>+
> 	new_json_obj_plain(dl->json_output);
> 	return 0;
>-
>-err_ifname_map_create:
>-	mnlu_gen_socket_close(&dl->nlg);
>-	return err;
> }
> 
> static void dl_fini(struct dl *dl)
>-- 
>2.37.1
>
