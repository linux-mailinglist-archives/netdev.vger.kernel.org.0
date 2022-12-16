Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A64464EB12
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 13:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiLPL7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 06:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiLPL7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 06:59:22 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C9E43848
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:59:21 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id d14so3254670edj.11
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gr2R5xN2FFDHeFzY63z4bPxLxYqb3yc7jcHIz/bXDbo=;
        b=Sajt1HHOprJ1BY58rALspCb1vtT/DcGW3eUIuPc+XXv+Gnv/kWxjuaFh5d8SlDvv2Z
         oOmgf8ah43ekwmdyW1m0MtVZanTXcW/yhThRHWRBErl3bOoFG/cPe8guzwtldcPHVk3+
         pt1ai2VpqGVDhNrDJhRK8nzVsZJY1zsv0GQZ1sOScLkViUKDSLH7JxbHHl6sA790Vd8h
         RN2A3e8kUjSb8bEDz1J7Wf1ODRenJRGAn2DIzYYjKE6qYw+05WTfkGbQD9sHjKy9V3Uu
         EXKKDvlPsvKQKM3Cq3DoWqvm+ApgDcZ5cgJnXL2PP2ihcgxwsA2aqG4CnoNdOSeYTXp5
         xNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gr2R5xN2FFDHeFzY63z4bPxLxYqb3yc7jcHIz/bXDbo=;
        b=O3gGcWy9Sieu6dduvk9oHy6UnTJ3CHxIcziiObqJafouVMi5cGGi75VbHlYKR6uQi0
         XvCZQNwnXMqLLu4r2zQskyz86o7kQNrrJqbRAhRM48ofPk+GkLu0+2juJbyE72G1+88e
         95Ss9n+olq3Wg/gnPMbzMXGBXXk0Hu1wn7HEWLml+vZ/dvmACpLzP3umRpiFsRg1tRwm
         gQDGL5T3zip5iL40WRN1FVX+HPjEiXNqdrHUTGWO/Zq9LDKaMEOM0pPi9trwVdeH2yfW
         IZAovUyu435KYWWh5zygsRraeT3wmxa1seVbJOa5vFmqAgJ8lkfpkk8/XAgZPBGQQ5/F
         j8Ww==
X-Gm-Message-State: AFqh2kqKmadIONO9KMoEaCUwucg9NJTzdzswLG7ICVVyVExFRGQCiWSM
        OxneJWQMuCEbaJqdGsnAL21NlSm74JWBiswAfE0=
X-Google-Smtp-Source: AMrXdXv1bFx6ZUXTXIjSnwhEq1RcFfODKWdS3MRDYIsLjcvzDSgQsmBWWCr5AOu6CcsaOsppRh8rQg==
X-Received: by 2002:a05:6402:1057:b0:474:a583:2e25 with SMTP id e23-20020a056402105700b00474a5832e25mr4201511edu.5.1671191959588;
        Fri, 16 Dec 2022 03:59:19 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id dk11-20020a0564021d8b00b0046c91fa5a4asm775747edb.70.2022.12.16.03.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 03:59:19 -0800 (PST)
Message-ID: <680da65d-a8a4-5809-6d9a-62ee05ff86b6@blackwall.org>
Date:   Fri, 16 Dec 2022 13:59:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH iproute2-next 1/6] bridge: mdb: Use a boolean to indicate
 nest is required
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@nvidia.com
References: <20221215175230.1907938-1-idosch@nvidia.com>
 <20221215175230.1907938-2-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221215175230.1907938-2-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/12/2022 19:52, Ido Schimmel wrote:
> Currently, the only attribute inside the 'MDBA_SET_ENTRY_ATTRS' nest is
> 'MDBE_ATTR_SOURCE', but subsequent patches are going to add more
> attributes to the nest.
> 
> Prepare for the addition of these attributes by determining the
> necessity of the nest from a boolean variable that is set whenever one
> of these attributes is parsed. This avoids the need to have one long
> condition that checks for the presence of one of the individual
> attributes.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/bridge/mdb.c b/bridge/mdb.c
> index d3afc900e798..4ae91f15dac8 100644
> --- a/bridge/mdb.c
> +++ b/bridge/mdb.c
> @@ -488,6 +488,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
>  	};
>  	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL;
>  	struct br_mdb_entry entry = {};
> +	bool set_attrs = false;
>  	short vid = 0;
>  
>  	while (argc > 0) {
> @@ -511,6 +512,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
>  		} else if (strcmp(*argv, "src") == 0) {
>  			NEXT_ARG();
>  			src = *argv;
> +			set_attrs = true;
>  		} else {
>  			if (matches(*argv, "help") == 0)
>  				usage();
> @@ -538,7 +540,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
>  
>  	entry.vid = vid;
>  	addattr_l(&req.n, sizeof(req), MDBA_SET_ENTRY, &entry, sizeof(entry));
> -	if (src) {
> +	if (set_attrs) {
>  		struct rtattr *nest = addattr_nest(&req.n, sizeof(req),
>  						   MDBA_SET_ENTRY_ATTRS);
>  		struct in6_addr src_ip6;

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

