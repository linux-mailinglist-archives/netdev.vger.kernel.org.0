Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE7F647075
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 14:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLHNG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 08:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiLHNGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 08:06:54 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2B792A23
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 05:06:51 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id vv4so3714555ejc.2
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 05:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j7y7mXoiRYM8+gZyOMzLUWwVsrDJFgNfdOoDhY7I1hA=;
        b=QhhF3HkYaexoVfJbdwuHNaq4sMJ+Nk16bnoGP7jJJb7a/Oc99VPO2S60SzklpxzHhK
         dJnPqCq20C25lqYhFym4XvwQu65gb6pl7ZZ5B9E5sTRGXaaJiPMUgHlgCCcyYebPycgU
         ifaR2JTex+NNDy0r/oI67pvVciHJJ8OZgKS+E403wMyV8vMfbO7twR2jjU67eArl7btJ
         GRO9MK/hd5tBE5goa7Qd2wwj99rSblOH+fHYNiA62jcw3g5Eg4VM7RrADkQpj++WjX2T
         JkWJnl3iLupTy6EqZ54XyCfEmSipYSqup4YHF4hlRClA0wYE5zltCIugSPwPnjv7VNtX
         jAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j7y7mXoiRYM8+gZyOMzLUWwVsrDJFgNfdOoDhY7I1hA=;
        b=yDsUFbI8KprIP+jltBBlysqVXFG83oG3SKirpb0qXPs2fiWGgRoWHgsOLKX44K6IKO
         uAx/QyKk+DiWJTHpoZVsGd4sjmPQZzKphv850RKJhWTP5RVM2hRn0pCHKap9onEPlmDh
         edeXETYcDK+se5Jn71ycMrPEH0+iqCOsrxwz3+ZEQHuCoi5O4X0r9J0/lC8BbQ+1CkqS
         BsWDzky2jxePocL9ZxMtODts3QdSLD5TzbSEZaIs5zZtxcbnf2J5Gg1qFsVkXailHCAR
         Gqqil5jRLqixrZxFD1uofn1Z/ZZX8YQO27YGW2VFhJERFNUD9/vraC9zF/caxp3FdSFQ
         8eoA==
X-Gm-Message-State: ANoB5pnp3pBJ/rdwYSDNGdMiZLuCnvx6wVlFcdo5iWtdrV/GxOfwOZ/4
        deomC4NEovU6VKoSHiikVEuuQw==
X-Google-Smtp-Source: AA0mqf4aEkLvSoesNyuO9RAmKvnynXKYC/lLSIrkJohqLRpK2kurlnF35xYRAlYzs/b6H0+yAIGnGw==
X-Received: by 2002:a17:906:4cd0:b0:7ad:c3b5:8d55 with SMTP id q16-20020a1709064cd000b007adc3b58d55mr1789236ejt.67.1670504810463;
        Thu, 08 Dec 2022 05:06:50 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v16-20020a1709061dd000b007b47749838asm9609320ejh.45.2022.12.08.05.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 05:06:49 -0800 (PST)
Date:   Thu, 8 Dec 2022 14:06:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     leon@kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] ice: Add check for kzalloc
Message-ID: <Y5HhaLOle2tZuT9S@nanopsycho>
References: <20221208125847.45342-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208125847.45342-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 01:58:47PM CET, jiasheng@iscas.ac.cn wrote:
>As kzalloc may return NULL pointer, the return value should
>be checked and return error if fails in order to avoid the
>NULL pointer dereference.

It would be nice if you change the sentence above to imperative mood.
Tell the codebase what to do.


>Moreover, use the goto-label to share the clean code.
>
>Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
>Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>---
>Changelog:
>
>v2 -> v3:
>
>1. Use "while (i--)" to simplify the code.
>
>v1 -> v2:
>
>1. Use goto-label to share the clean code.
>---
> drivers/net/ethernet/intel/ice/ice_gnss.c | 23 ++++++++++++++---------
> 1 file changed, 14 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
>index b5a7f246d230..90c620c26516 100644
>--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
>+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
>@@ -462,6 +462,9 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
> 					       GFP_KERNEL);
> 		pf->gnss_serial[i] = NULL;
> 
>+		if (!pf->gnss_tty_port[i])
>+			goto err_out;

Move the check right after the alloc.


>+
> 		tty_port_init(pf->gnss_tty_port[i]);
> 		tty_port_link_device(pf->gnss_tty_port[i], tty_driver, i);
> 	}
>@@ -469,21 +472,23 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
> 	err = tty_register_driver(tty_driver);
> 	if (err) {
> 		dev_err(dev, "Failed to register TTY driver err=%d\n", err);
>-
>-		for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
>-			tty_port_destroy(pf->gnss_tty_port[i]);
>-			kfree(pf->gnss_tty_port[i]);
>-		}
>-		kfree(ttydrv_name);
>-		tty_driver_kref_put(pf->ice_gnss_tty_driver);
>-
>-		return NULL;
>+		goto err_out;
> 	}
> 
> 	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++)
> 		dev_info(dev, "%s%d registered\n", ttydrv_name, i);
> 
> 	return tty_driver;
>+
>+err_out:
>+	while (i--) {
>+		tty_port_destroy(pf->gnss_tty_port[i]);
>+		kfree(pf->gnss_tty_port[i]);
>+	}
>+	kfree(ttydrv_name);
>+	tty_driver_kref_put(pf->ice_gnss_tty_driver);
>+
>+	return NULL;

This looks fine now.


> }
> 
> /**
>-- 
>2.25.1
>
