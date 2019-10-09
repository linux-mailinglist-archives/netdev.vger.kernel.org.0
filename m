Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274A2D0D6E
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 13:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbfJILNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 07:13:44 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51495 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbfJILNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 07:13:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so2064764wme.1
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 04:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hmxZh6mjPnnGtVNW6IwVQja/W6GtMktIwRqoY61k7PU=;
        b=BfoKUMwUoVeuh2lZxDFumvBZ+EHiFfLFnHlMdJGKdB7aXrXDZ67je1PXladwCf4Z8z
         /G6mLKsy/3v6qlaNqayibV3iCoNtUdSEAEtMQXmJfVG4Aj/mujYVu6mq96dXLE4RYktk
         rllyYP5WtsR10hMx3oWzO69avDXzJ2rzRle8j4AZhCgZetkgU34+tLUpCvFUKGUDqV39
         qiYZIL6JhMnwFBd7ivHdaR79hKkYmz37qZUaniRhHX9zbzrMVL4i1VJj5yHcRgakEmmB
         QhrUciyds71LwxgdjWOc6rAUjDOHKrl95hhEcPfi8a9TnhkRGz8i1oXP0qbsF+4wCotd
         tyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hmxZh6mjPnnGtVNW6IwVQja/W6GtMktIwRqoY61k7PU=;
        b=qIzk1TgADIVaoMLGwGoozaKNzzfYhTsNukYfYOsKbY1Ydc6gjh8PTn/CVn5FQIv/qs
         k4cZgUxscXLIGwyjE06GcRY40jyV9JQ3zklECk6VzxiMqP4BtGKnTWM97Y8Tc9aiN/qg
         R9OWcAXLMZhIZFeiYDzTq7FDFz5ZvHRYMftArAwaoV+jbfI57aKcF7NKzvn2KCCSfSNI
         X8zaeBuGrEZBEOdEWs8oXQzxrENbpWgoDQfJ8IqXRF4+L72qAqOwKaOLOde6vsT/WWG2
         K707yycjrx5i+ZCh9V9C9IXwaWm/KzpI1s6fOKuybpNDLJFbGycAtjhWIFhLkO8fo5t1
         cTcQ==
X-Gm-Message-State: APjAAAUG53p3w81+mIEy/oc91rcQRHZQXmp9tXhsVODkaiNANHhJIxPY
        0YSoCowXR1Mq+PDS8DrtQnuJ5Q==
X-Google-Smtp-Source: APXvYqwGCN393PzdMfIuGRClt2DnhUC+ggT5zSSyA58kEZbAQOWAUMAURTxx5BJdfy9RcZ5vISfg2w==
X-Received: by 2002:a1c:5609:: with SMTP id k9mr2133072wmb.103.1570619620368;
        Wed, 09 Oct 2019 04:13:40 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id 36sm2882502wrp.30.2019.10.09.04.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:13:39 -0700 (PDT)
Date:   Wed, 9 Oct 2019 13:13:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, roopa@cumulusnetworks.com,
        dcbw@redhat.com, nikolay@cumulusnetworks.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        f.fainelli@gmail.com, stephen@networkplumber.org,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2-next v2 1/2] ip: add support for alternative
 name addition/deletion/list
Message-ID: <20191009111339.GH2326@nanopsycho>
References: <20191002105645.30756-1-jiri@resnulli.us>
 <20191002105645.30756-2-jiri@resnulli.us>
 <48c341d6-d611-3f4e-a64d-85719af7ed45@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48c341d6-d611-3f4e-a64d-85719af7ed45@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 07, 2019 at 11:37:21PM CEST, dsahern@gmail.com wrote:
>On 10/2/19 4:56 AM, Jiri Pirko wrote:
>> diff --git a/ip/iplink.c b/ip/iplink.c
>> index 212a088535da..e3f8a28fe94c 100644
>> --- a/ip/iplink.c
>> +++ b/ip/iplink.c
>> @@ -111,7 +111,9 @@ void iplink_usage(void)
>>  		"\n"
>>  		"	ip link xstats type TYPE [ ARGS ]\n"
>>  		"\n"
>> -		"	ip link afstats [ dev DEVICE ]\n");
>> +		"	ip link afstats [ dev DEVICE ]\n"
>> +		"	ip link prop add dev DEVICE [ altname NAME .. ]\n"
>> +		"	ip link prop del dev DEVICE [ altname NAME .. ]\n");
>
>spell out 'property' here. The matches below on "prop" is fine, but the
>help can show the full name.

Okay.


>
>
>> +
>> +	if (matches(*argv, "add") == 0) {
>> +		req.n.nlmsg_flags |= NLM_F_EXCL | NLM_F_CREATE | NLM_F_APPEND;
>> +		req.n.nlmsg_type = RTM_NEWLINKPROP;
>> +	} else if (matches(*argv, "del") == 0) {
>> +		req.n.nlmsg_flags |= RTM_DELLINK;
>
>RTM_DELLINK is a command not a netlink flag.

Will fix.

