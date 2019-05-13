Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 861CB1B989
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfEMPHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 11:07:52 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36360 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbfEMPHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 11:07:52 -0400
Received: by mail-pl1-f194.google.com with SMTP id d21so6646369plr.3
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 08:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oi5ZfGEF16tBD3VAaqVwNWVBQk9X5G5CXgGgJqC4gDs=;
        b=QYflIImHgvYB7tt8cQ/92eFj4DQMosFvWgdShfhhAL3OunUVUTmBvTCVf+a13L8FLz
         /4T/52OasLKthZvJmc8JP0R/x+R3SY2bY5P1x96NfCyegwYlfRi2u3Pygo/DJmCgecnr
         AYzwbH8m9RAPZGdIoytVLbzZDMYADi+jBRWFR/B3zWpAgfyHYuFCy2MCQjhLmlX0ADCQ
         I7elzYcQdCNpCNL+MJNk+9viaSmxCsXaNGy10WVjz6BvPN3TaQW1TsyJdnEK/HSCMkob
         cEkrjDgolCt0UuQb2xiNvayF5iD65Cw/oyDzfDWZK64YSGIX048HIAx0CacBnUQHqDcX
         l+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oi5ZfGEF16tBD3VAaqVwNWVBQk9X5G5CXgGgJqC4gDs=;
        b=M1V7S+meKRyl5JM10sevBdelBMCBeY3ihFQyX7Tg4kKJqta3WFt30PZThw/4M3O1am
         srsUUOt8em9XIQZDdH6tsLiSmSM3IgQtlT9K5ao9Qm0VVasoavkN0QvZ/GqeFIRFJobw
         SzzgX97ZfItvZZs15xO8y5MMjidQ1+FsOTeHChf6skpuqvOy4YsuWwm/YLgiFPtyEa1S
         SZErL/lXGC8gbrnNukbJwVDinVyOFVIkySM6wYf/pHv5vD7SejzzAALYEaHoJAzmvinH
         M0zPxux7fS1EsTnNkFH5lBPHBMvuw8TjRbes95b0NR0mUM3g16M9/zQPruYRwLhne4lQ
         o8kA==
X-Gm-Message-State: APjAAAXDxXPT8L3gH8G3EYskllm3+VFcN6OSSSzZRPcguuDF3Z3Cld3N
        tQh9BnJ/Epuu0xL7c14mHBQ=
X-Google-Smtp-Source: APXvYqyMo42WBughgk1RHOaLavMfN3UoZjx6KtZY0lnaG2nDXT0WBv65ERyUkkfiHOslNnQIU5AZOQ==
X-Received: by 2002:a17:902:860c:: with SMTP id f12mr32028207plo.127.1557760071438;
        Mon, 13 May 2019 08:07:51 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:5dd:49d5:5580:adf5? ([2601:282:800:fd80:5dd:49d5:5580:adf5])
        by smtp.googlemail.com with ESMTPSA id p2sm34551122pfi.73.2019.05.13.08.07.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 08:07:50 -0700 (PDT)
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     Dan Winship <danw@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9974090c-5124-b3a1-1290-ac9efc4569c4@gmail.com>
Date:   Mon, 13 May 2019 09:07:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/19 7:47 AM, Sabrina Dubroca wrote:
> Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
> iflink == ifindex.
> 
> In some cases, a device can be created in a different netns with the
> same ifindex as its parent. That device will not dump its IFLA_LINK
> attribute, which can confuse some userspace software that expects it.
> For example, if the last ifindex created in init_net and foo are both
> 8, these commands will trigger the issue:
> 
>     ip link add parent type dummy                   # ifindex 9
>     ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo
> 
> So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
> always put the IFLA_LINK attribute as well.
> 
> Thanks to Dan Winship for analyzing the original OpenShift bug down to
> the missing netlink attribute.
> 
> Analyzed-by: Dan Winship <danw@redhat.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
> v2: change Fixes tag, it's been here forever as Nicolas said, and add his Ack
> 
>  net/core/rtnetlink.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 2bd12afb9297..adcc045952c2 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1496,14 +1496,15 @@ static int put_master_ifindex(struct sk_buff *skb, struct net_device *dev)
>  	return ret;
>  }
>  
> -static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev)
> +static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev,
> +			  bool force)
>  {
>  	int ifindex = dev_get_iflink(dev);
>  
> -	if (dev->ifindex == ifindex)
> -		return 0;
> +	if (force || dev->ifindex != ifindex)
> +		return nla_put_u32(skb, IFLA_LINK, ifindex);
>  
> -	return nla_put_u32(skb, IFLA_LINK, ifindex);
> +	return 0;
>  }
>  
>  static noinline_for_stack int nla_put_ifalias(struct sk_buff *skb,

why not always adding the attribute?
