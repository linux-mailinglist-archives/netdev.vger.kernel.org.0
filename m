Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5176A41D1D6
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346735AbhI3D2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244576AbhI3D2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:28:08 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2332EC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:26:27 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id r43-20020a05683044ab00b0054716b40005so5572485otv.4
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gcybzi5N/B6qs9Zp0Dw1cu3LQeocIwSjKSxPq+PJt9M=;
        b=gPitrKc8nvf26sw+LA6sac1oP6AxutFo9BN94MpYHGXQdkkCLhrjpvr4Ns560PwR+o
         8t2atBlfcJLa4DgqIKCrSA/88Qwf8w9WA83eJzc25kKRcHvIQVv6xI8bGiGCfmCb8inH
         +4TjhjBDa+YNNcnRJ/eECUAbSPac9Gy4N2BzeJ96MElQSFvvRONy/Qo3dnk5yuTZ7GlW
         gYjuWLJP30aQxpp9bCKvxeSXAkwZ5HMvfhQhtkb01rfn9qcki66Sd5LhDsxCN9dXXQ9B
         p+MAAX3CSjfzU8chP8UjR90Wuq82QAkdbrdwaqRDR+PkWpD6BCS+z3TL4L84pzCOTlY1
         Gx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gcybzi5N/B6qs9Zp0Dw1cu3LQeocIwSjKSxPq+PJt9M=;
        b=J6WonpBZi9yWoXsC+NrveeKSpkvDkErkGr+5sjYnAdA0CPRhEyZcgA3N9bRweJAliY
         M3POQOx845u624TSVqGV5sKa8cnYpaxUcdZSeR3jHfSFH4I2UVsuTBDUID3hdbDlCcl6
         i6xTZ6INOpihr62oPTguAs4r2tCwkOGvOt+ZGH+yq1EC2XWcv2Yg1jheOHXjXF8lE5cy
         nsPORTbWr4m1UE93gFWCMNexpEQxTbv/CciabwetlBegPzuc/M+29MISzykuHrNdHhHg
         sh3dRqnbv1F1/QPQAK2L0LEbFRPv5Coj2L0AJIzNaGImYF28PEkEBzb4a1VtmP6aN5Ou
         jUzg==
X-Gm-Message-State: AOAM533U7xxBIT90T3QaPYW0j7M39FDLkvNIZ/etazCl7x92CYQOzafL
        6UfmTTTA59W/XXnytGxidLc=
X-Google-Smtp-Source: ABdhPJwTlFdnWNSvt4SONjbfHUKhnH8XQMvHJSGOEVuwaM8Ca8+H77j5Y03+GQLPFaR7CjV30T0mzw==
X-Received: by 2002:a05:6830:1d4e:: with SMTP id p14mr3297954oth.244.1632972386495;
        Wed, 29 Sep 2021 20:26:26 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 98sm350759oth.29.2021.09.29.20.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 20:26:25 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] ipv6: ioam: Add support for the ip6ip6
 encapsulation
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
References: <20210928190328.24097-1-justin.iurman@uliege.be>
 <20210928190328.24097-2-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <16630ce5-4c61-a16b-8125-8ec697d6c33e@gmail.com>
Date:   Wed, 29 Sep 2021 21:26:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928190328.24097-2-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/21 1:03 PM, Justin Iurman wrote:
> @@ -42,34 +49,15 @@ static struct ioam6_lwt_encap *ioam6_lwt_info(struct lwtunnel_state *lwt)
>  	return &ioam6_lwt_state(lwt)->tuninfo;
>  }
>  
> -static struct ioam6_trace_hdr *ioam6_trace(struct lwtunnel_state *lwt)
> +static struct ioam6_trace_hdr *ioam6_lwt_trace(struct lwtunnel_state *lwt)
>  {
>  	return &(ioam6_lwt_state(lwt)->tuninfo.traceh);
>  }
>  
>  static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
> -	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_trace_hdr)),
> +	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_iptunnel_trace)),

you can't do that. Once a kernel is released with a given UAPI, it can
not be changed. You could go the other way and handle

struct ioam6_iptunnel_trace {
+	struct ioam6_trace_hdr trace;
+	__u8 mode;
+	struct in6_addr tundst;	/* unused for inline mode */
+};

Also, no gaps in uapi. Make sure all holes are stated; an anonymous
entry is best.


>  };
>  
> -static int nla_put_ioam6_trace(struct sk_buff *skb, int attrtype,
> -			       struct ioam6_trace_hdr *trace)
> -{
> -	struct ioam6_trace_hdr *data;
> -	struct nlattr *nla;
> -	int len;
> -
> -	len = sizeof(*trace);
> -
> -	nla = nla_reserve(skb, attrtype, len);
> -	if (!nla)
> -		return -EMSGSIZE;
> -
> -	data = nla_data(nla);
> -	memcpy(data, trace, len);
> -
> -	return 0;
> -}
> -

quite a bit of the change seems like refactoring from existing feature
to allow the new ones. Please submit refactoring changes as a
prerequisite patch. The patch that introduces your new feature should be
focused solely on what is needed to implement that feature.
