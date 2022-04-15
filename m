Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0E3502D7A
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355705AbiDOQH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355698AbiDOQH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:07:27 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6C4522FC;
        Fri, 15 Apr 2022 09:04:57 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bh17so16049764ejb.8;
        Fri, 15 Apr 2022 09:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=112dwm8QpeyoKYHzXDlM/vsE5hIZxIAtes3nuwV/SSo=;
        b=q1bzqzL3lBdyltYHc9DTIT5JLPdLODWLZph8x8M5S6Lrx38YGPco66753ypyqSZHdS
         TsBVCJ5EpLAbAmZd7rn35rz5+5MFo5cmcPhwTg2EsuyzzljP5OF0i5quSN5Bq79dJupT
         XxChUcD2MsVarL7yLizfAjcN3B0NTqgueTBK61H9jo+fIJq2L7zfnVfyEtuLdKfBrIhL
         iDzvx73Aqc0XvRiY1AXXQbSKFoZMT0Gp0iczLfr/jN0opuxhWCDc6rZaQadXhtc1zVzT
         V6fOjszCUEV1CJPEyDoo3WVMYNJOQYRIdd2ngW2MNMxLobrauU5wyg1fn/2XkaL6GqdW
         ZQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=112dwm8QpeyoKYHzXDlM/vsE5hIZxIAtes3nuwV/SSo=;
        b=bpzv/9rAOTway6XtxAJ9OiD2W1UsZv4UGvvj4vYu0UNxwdJuytBYcHGI4KIBuPjDIJ
         ZULMXiur7n7ce0JTi2N5lwi0BTFT6YVt505LBxJ2/Oqi1DSCrF24fwodcjFiTr8Li9Ap
         x5II0WE5hSak2iMnnxF4GgaH3pkvvo/I4TnfKqWzB93oLKJvB/dEuCMO6NJI1f8xn03l
         uYJ8a/qPQgWXdJG178s6SomwXT0Xfvu7wqIzsxEgWhJ5lBMlBEzbTnzihE2/0xotCvFg
         /MeJY4NEQEaZ7r8wG5aY/bH8V7A0l8oJRSrO+gFe0tyfjE1nvCSOzc8juCwnblXSPUNO
         rESA==
X-Gm-Message-State: AOAM532xIJ76AaRlsWEtlBKlsbj4HGA8wXFvk5c7OF1aLnuylpsz5RUn
        X8zyIfeNaeRg5pYIJwRxCGI=
X-Google-Smtp-Source: ABdhPJw48aM/ILhX7ieEo4E/2JT/l4q8QZCfn54tMQSw+A5qviAhPCWJlSaz9aHJH2xpZA3vw595cw==
X-Received: by 2002:a17:907:6e88:b0:6da:8f01:7a8f with SMTP id sh8-20020a1709076e8800b006da8f017a8fmr6648623ejc.619.1650038696267;
        Fri, 15 Apr 2022 09:04:56 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id r18-20020a05640251d200b0041d1600ab09sm3036190edd.54.2022.04.15.09.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 09:04:55 -0700 (PDT)
Date:   Fri, 15 Apr 2022 19:04:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next v4 07/18] net: dsa: Replace usage of found with
 dedicated list iterator variable
Message-ID: <20220415160452.z4m4j3sulcteqggs@skbuf>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
 <20220415122947.2754662-8-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415122947.2754662-8-jakobkoschel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 02:29:36PM +0200, Jakob Koschel wrote:
> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
> 
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable instead of a
> found boolean [1].
> 
> This removes the need to use a found variable and simply checking if
> the variable was set, can determine if the break/goto was hit.
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
> ---

I absolutely hate the robotic commit message, but the change looks like
it works, so:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  net/dsa/dsa.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 89c6c86e746f..645522c4dd4a 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -112,22 +112,21 @@ const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
>  
>  const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol)
>  {
> -	struct dsa_tag_driver *dsa_tag_driver;
> +	struct dsa_tag_driver *dsa_tag_driver = NULL, *iter;
>  	const struct dsa_device_ops *ops;
> -	bool found = false;
>  
>  	request_module("%s%d", DSA_TAG_DRIVER_ALIAS, tag_protocol);
>  
>  	mutex_lock(&dsa_tag_drivers_lock);
> -	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
> -		ops = dsa_tag_driver->ops;
> +	list_for_each_entry(iter, &dsa_tag_drivers_list, list) {
> +		ops = iter->ops;
>  		if (ops->proto == tag_protocol) {
> -			found = true;
> +			dsa_tag_driver = iter;
>  			break;
>  		}
>  	}
>  
> -	if (found) {
> +	if (dsa_tag_driver) {
>  		if (!try_module_get(dsa_tag_driver->owner))
>  			ops = ERR_PTR(-ENOPROTOOPT);
>  	} else {
> -- 
> 2.25.1
> 
