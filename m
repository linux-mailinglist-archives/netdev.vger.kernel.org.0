Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA278A2D0
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 18:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfHLQCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 12:02:06 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43693 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfHLQCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 12:02:05 -0400
Received: by mail-ot1-f67.google.com with SMTP id e12so16417865otp.10
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 09:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TgnolfB/jUL83PgFIzu2F64d82Zph8SbM8CPOCJYrnw=;
        b=dR0E6S4kcKA5DuzE8n0oLxk3UhtHE/48ZbN4JhygsywwVAmKb0+o1jCmNNMbQVwVQf
         PJuolETN35EfAiQhOqmW6lDhFvAHvAW0/F5SEcfosiX8yTkIiMka+dulCF4CMvz7zFje
         YMpFU3HwAKvJIG/zOMG8sZFasLm6y6YzIPeEQo77vsDMxTG7+gYMykb78ZmYjNqW84qV
         8CJjUSZKmD1Tf5GTPPKlI8+Tg5bcL//cBReSMRrKdkt/CQkkY0NR49l3rgml6ls6AdKH
         1/nmuBOFFC9slxQzzlwR5NkpGxnRYf05Cnws5+zfoFQS95/TFAA2g5eYV1Oh4Rrcg8NL
         j5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TgnolfB/jUL83PgFIzu2F64d82Zph8SbM8CPOCJYrnw=;
        b=FirOnreL1OiKmw5mNu6EI8uDLdWql6o1CG93F+kWnCfx3GRiK6Vp/zCEnCnJqlt7i4
         kuvuSYjj7PzLQjQMeB528fr1r/uCno375Q9K8Ek0y7lAXPE8GOier3J1W0984CSQbAQA
         zJ5G7V7egYXaqTjk+KgDPwuauz7S+TjSIqTJuNEkkNCqfR8v91S34orfam/JMj7mboV9
         p19ywzyd5MvzM6J8/Ty01AvCHGUTh989PzPmP/3VkGnH1M4qwmrKnG8JAi0pJMrzmN2W
         GNfmgDTEL0Vi367iSUnpXT6/4wdZu98lRohp2nNGRGBTCWq6IDHjT5L0n6cDWs0+jr1u
         Vglg==
X-Gm-Message-State: APjAAAX/8Rjc3lyb3eQtxZnwp9Hh3oRPFCPdeNGxJIyYzHPDTU7HDev6
        74ALazVT1gh3iffbh+d+ZM8=
X-Google-Smtp-Source: APXvYqy/uPgeV5L2lCrQmPLUybbsdyP/JOYD+c/iFsnC3y3GgIVnVY04SfUit4bWcS2yIDOZD3Adgw==
X-Received: by 2002:a5d:96d8:: with SMTP id r24mr35736994iol.269.1565625724604;
        Mon, 12 Aug 2019 09:02:04 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:1567:1802:ced3:a7f1? ([2601:282:800:fd80:1567:1802:ced3:a7f1])
        by smtp.googlemail.com with ESMTPSA id o3sm17277475ioo.74.2019.08.12.09.02.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 09:02:03 -0700 (PDT)
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b43ad33c-ea0c-f441-a550-be0b1d8ca4ef@gmail.com>
Date:   Mon, 12 Aug 2019 10:01:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190812083139.GA2428@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 2:31 AM, Jiri Pirko wrote:
> Mon, Aug 12, 2019 at 03:37:26AM CEST, dsahern@gmail.com wrote:
>> On 8/11/19 7:34 PM, David Ahern wrote:
>>> On 8/10/19 12:30 AM, Jiri Pirko wrote:
>>>> Could you please write me an example message of add/remove?
>>>
>>> altnames are for existing netdevs, yes? existing netdevs have an id and
>>> a name - 2 existing references for identifying the existing netdev for
>>> which an altname will be added. Even using the altname as the main
>>> 'handle' for a setlink change, I see no reason why the GETLINK api can
>>> not take an the IFLA_ALT_IFNAME and return the full details of the
>>> device if the altname is unique.
>>>
>>> So, what do the new RTM commands give you that you can not do with
>>> RTM_*LINK?
>>>
>>
>>
>> To put this another way, the ALT_NAME is an attribute of an object - a
>> LINK. It is *not* a separate object which requires its own set of
>> commands for manipulating.
> 
> Okay, again, could you provide example of a message to add/remove
> altname using existing setlink message? Thanks!
> 

Examples from your cover letter with updates

$ ip link set dummy0 altname someothername
$ ip link set dummy0 altname someotherveryveryveryverylongname

$ ip link set dummy0 del altname someothername
$ ip link set dummy0 del altname someotherveryveryveryverylongname

This syntactic sugar to what is really happening:

RTM_NEWLINK, dummy0, IFLA_ALT_IFNAME

if you are allowing many alt names, then yes, you need a flag to say
delete this specific one which is covered by Roopa's nested suggestion.
