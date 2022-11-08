Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09115621B5A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiKHSBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiKHSBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:01:21 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363611FCE5
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:01:20 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id f8so9570509qkg.3
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 10:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wDrq2KVoUCxkhxO6WpTTyZbqFCb6qloqTFLoADCq7ok=;
        b=hZMmHshSNADKZamj2Bl4ylyYFEWjU0kz6N9zuO1+U0zleujiKgoM4TX0bM6OZUqaEm
         pQSgJbEgzt5ZYsl9FcgDapOpJe7HScO3RHf6B2R6hICdI7zpCNaNDqKbCJ1CyH76TRk/
         4ztAez3Nio3lp9AX6bo+xtsZX8SZPPP8P0oz//bM1WfdQ94tgxZEwVJ67QdA7mXnV7bO
         c1Q2v3yUADNOyalJSL1ZKqXE42AQR0n8A85gW1qgi04Jj+YO5F2o10JDLw4qtwm90P7c
         PM1A596+wCzDo28uMju9vCNyIFX8PlcHqsgzzC5WiP0KduUyOVhANmWdN1JF5yEVyg3Y
         StDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wDrq2KVoUCxkhxO6WpTTyZbqFCb6qloqTFLoADCq7ok=;
        b=rNuiSz+5hyzumHBLcCHsJvxIu8+L0c9ij6ARsFoDr0JXHx2MR/sprZyqv+CZhsH88E
         NYXX9y2thxSYweTnbCLF1MUTo1j7hSsfRAS0mo9gkih++0LfYq+iD7GjGn3Br8O6vadn
         oxmt/No+srxFFCLlUnBdMo77azbtEmnVRMUAVB2rZDbgkKGA5PYYcKd6bHz0kt61HSsh
         NOhmEkXymxpPviGayZJo7n2Zu8dsKMROxdn/HhdKhW5yGlUVkY+Abn+DbpzXcPcIfEcD
         OrGP+SpqAQsWjodra3rbA0PwDkShekFgjlIdt5kmyHC/HF5AcJzYGY27ZlWfNrzqvd+d
         r8Ag==
X-Gm-Message-State: ACrzQf0UwAQ48x5MKUjAickevlmXqmo0/nQd51GGumHY3ATAgS1td2Zg
        NrT8MJpavtiKzxci6G0S6XALug==
X-Google-Smtp-Source: AMsMyM6V3a1bvL7jFhwBqAbRZpo9uWNWSNj6kJ3C29vh48hZBL/Ba/02cilmAWsAe5UKEFttiCKbXg==
X-Received: by 2002:a37:e30d:0:b0:6fa:6241:c858 with SMTP id y13-20020a37e30d000000b006fa6241c858mr24147792qki.553.1667930479206;
        Tue, 08 Nov 2022 10:01:19 -0800 (PST)
Received: from [127.0.0.1] ([190.167.198.156])
        by smtp.gmail.com with ESMTPSA id o16-20020a05620a2a1000b006cbe3be300esm10284211qkp.12.2022.11.08.10.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 10:01:18 -0800 (PST)
Date:   Tue, 08 Nov 2022 14:01:17 -0400
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org
CC:     Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net-next_01/15=5D_bridge=3A_switchdev=3A_Le?= =?US-ASCII?Q?t_device_drivers_determine_FDB_offload_indication?=
User-Agent: K-9 Mail for Android
In-Reply-To: <b266dcf6d647684a10984d12f98549f93fd378ab.1667902754.git.petrm@nvidia.com>
References: <cover.1667902754.git.petrm@nvidia.com> <b266dcf6d647684a10984d12f98549f93fd378ab.1667902754.git.petrm@nvidia.com>
Message-ID: <31C46FC0-3ABB-4FD1-B44B-D467C81C6340@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,RCVD_IN_SORBS_HTTP,
        RCVD_IN_SORBS_SOCKS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8 November 2022 06:47:07 GMT-04:00, Petr Machata <petrm@nvidia=2Ecom> wr=
ote:
>From: Ido Schimmel <idosch@nvidia=2Ecom>
>
>Currently, FDB entries that are notified to the bridge via
>'SWITCHDEV_FDB_ADD_TO_BRIDGE' are always marked as offloaded=2E With MAB
>enabled, this will no longer be universally true=2E Device drivers will
>report locked FDB entries to the bridge to let it know that the
>corresponding hosts required authorization, but it does not mean that
>these entries are necessarily programmed in the underlying hardware=2E
>
>Solve this by determining the offload indication based of the
>'offloaded' bit in the FDB notification=2E
>
>Signed-off-by: Ido Schimmel <idosch@nvidia=2Ecom>
>Reviewed-by: Petr Machata <petrm@nvidia=2Ecom>
>Signed-off-by: Petr Machata <petrm@nvidia=2Ecom>
>---
> net/bridge/br=2Ec | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: Nikolay Aleksandrov <razor@blackwall=2Eorg>

>diff --git a/net/bridge/br=2Ec b/net/bridge/br=2Ec
>index 96e91d69a9a8=2E=2E145999b8c355 100644
>--- a/net/bridge/br=2Ec
>+++ b/net/bridge/br=2Ec
>@@ -172,7 +172,7 @@ static int br_switchdev_event(struct notifier_block *=
unused,
> 			break;
> 		}
> 		br_fdb_offloaded_set(br, p, fdb_info->addr,
>-				     fdb_info->vid, true);
>+				     fdb_info->vid, fdb_info->offloaded);
> 		break;
> 	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
> 		fdb_info =3D ptr;

