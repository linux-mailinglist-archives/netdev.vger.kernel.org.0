Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2ABF3A2D
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfKGVLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:11:47 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:41969 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfKGVLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 16:11:46 -0500
Received: by mail-il1-f195.google.com with SMTP id z10so3143680ilo.8;
        Thu, 07 Nov 2019 13:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aup6p9AtFBGBH5ZYLE4NNHeC9Vp7LRD2YatyZvd2bV8=;
        b=O9MR8/3JFyQvaNmV56jJQ0UikqlrdGwgKc+kd9c/OcVgwnRAuEi+GGKfnZhDRYLTWG
         q0UWGRAtiuZor5MW6tmI0h+fB/c6ZF13DRuyNPFQCWuD9wSDsUPdXJfIx/GV51Gny1A0
         akPwhW8WU0Nxhoi0Yjh4AgEXIDu/lVIiCINkfoYsCxWmZZX5gqeUETxJb62ac2kzPqi4
         pfFEdX4W5IHZMRz6GU3zvFEt1zD+NE72opTLI77lZrlNF/3vRr+P9bQiiBnUIt/Vxgt2
         QfJg3crCncADOL60i+F3bYO+9lETDkwiSF9dgEB5LuFEJUvKjZpvndYTXmGk5HEDmEbK
         TilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aup6p9AtFBGBH5ZYLE4NNHeC9Vp7LRD2YatyZvd2bV8=;
        b=QX0dvpMXg4oSuLQlM48EV5gvYu1aoFvbaj3YC9G0H4zcjB7/+/k8hmGacbjTflLAJF
         +ahQ2xs+wDAzFRbLpUqwIRcuPA5tc7opS3hJA5olgIdmCXQl+2HBvDWCLVUNxoAXvaVG
         +8j1x2Pt8wij3cn4n2qqknHpx1zTBEsrLwGhUTLfeU7XPTcLMVeV75t8jHrnTKNQAaTE
         PcmtZXikA4Q5WGg2A+TL0eRRUf+Z3zCyg+4YP0X2idOc/Y7uRdROk6MOh8eW5XoCmtwt
         i77bHvPaLOQebZQ2TysKRiiHXb5/4ilngEc1Lzm9sJA+3s4m9ZTWv9ugFDbgHqh/iPLO
         d7yg==
X-Gm-Message-State: APjAAAV2jXgCDIgPyQLhpFTvDMP+9shOimxr+VwDfgoHB7mY2lIPPRik
        yd9l4NwcR3LnEwF3y4+GDoI=
X-Google-Smtp-Source: APXvYqxIKQwwdkV5H+t6aI1r/NCGpIQObAQX8IH3Ppzx2A8fxhMCBLR0J6LllJvG9xDPBeiBb7/+AA==
X-Received: by 2002:a92:ba09:: with SMTP id o9mr6369179ili.6.1573161105804;
        Thu, 07 Nov 2019 13:11:45 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:48b9:89c9:cd6f:19d4])
        by smtp.googlemail.com with ESMTPSA id c22sm289998ioa.23.2019.11.07.13.11.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 13:11:45 -0800 (PST)
Subject: Re: [PATCH v3 0/6] Add namespace awareness to Netlink methods
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?=
         =?UTF-8?B?4KS+4KSwKQ==?= <maheshb@google.com>,
        Jonas Bonn <jonas@norrbonn.se>
Cc:     nicolas.dichtel@6wind.com, linux-netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
References: <20191107132755.8517-1-jonas@norrbonn.se>
 <CAF2d9jjteagJGmt64mNFH-pFmGg_eM8_NNBrDtROcaVKhcNkRQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d34174c2-a4d4-b3da-ded5-dcb97a89c80c@gmail.com>
Date:   Thu, 7 Nov 2019 14:11:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CAF2d9jjteagJGmt64mNFH-pFmGg_eM8_NNBrDtROcaVKhcNkRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/19 1:40 PM, Mahesh Bandewar (महेश बंडेवार) wrote:
> On Thu, Nov 7, 2019 at 5:30 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>>
>> Changed in v3:
>> - added patch 6 for setting IPv6 address outside current namespace
>> - address checkpatch warnings
>> - address comment from Nicolas
>>
>> Changed in v2:
>> - address comment from Nicolas
>> - add accumulated ACK's
>>
>> Currently, Netlink has partial support for acting outside of the current
>> namespace.  It appears that the intention was to extend this to all the
>> methods eventually, but it hasn't been done to date.
>>
>> With this series RTM_SETLINK, RTM_NEWLINK, RTM_NEWADDR, and RTM_NEWNSID
>> are extended to respect the selection of the namespace to work in.
>>
> This is nice, is there a plan to update userspace commands using this?

I'm hoping for an iproute2 update and test cases to validate the changes.
