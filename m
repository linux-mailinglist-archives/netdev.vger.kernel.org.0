Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF80147329
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAWVdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:33:46 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33361 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWVdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 16:33:46 -0500
Received: by mail-qk1-f196.google.com with SMTP id h23so41280qkh.0
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 13:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2kZBIZDGJE1mY23J2b4z4nQ5/t2ceLI18V1fahF19FQ=;
        b=VGikiLkMC/uohguNA/STZexe4t42oX4EGq5y2+D9TyuTPybX+IVPp1RoATVX/Iq/hv
         eJlk81hP+bAg2tVfujzlZdnCIM7srsfgNV8Zarw9MOoZyvtteZ03oo93mem4pp2e0rip
         TNqAQeHckeWHLVTcJUKjBeBKBkuFZIeXLtN+Y5nCI9kpzyO2/03mtVkEJW5lUnbd72S/
         hMf145u37jb4gLX7xTKV6YapFCN0DXugT++R/C50ZxQLuYc17gQ46c2K+KJ4Im8zf5LN
         72jt7FHoCv72pg+j4fDA/J7oSLgdAK+/ICcuDx85Ff8TgyDgnCya6XXvDjV8uW0GGb79
         UbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2kZBIZDGJE1mY23J2b4z4nQ5/t2ceLI18V1fahF19FQ=;
        b=Idg5p5Q0fzCgNKiSjlmpLJ6EoaSGXu/aCOZ066R18ChUI+11meq8lQmceoUgRDcOLt
         iwB3Y60JzUFVb4QyaqPyIqFw/qcWJQkDcTD/0OSwkG0MURgIPlM48HFkiBB+Qj21so1c
         qzyKDnIcVHnXjoCTHufdoVB8so/9nAewdJdFhocWX4/wMatPcFxYJnPNCGDWB1+iLBRR
         rG6TQZRpdm3IcyaSsDddx0if7IQA2QLaCBZkKXht60FQK9GBf17ZsIq6QvKHBMSOwAnd
         dkTdICwUjiOjlduQ6LQI2J21yBmHOxEGl+ae89WVGhjy6KQtnvS8URZ+CMj2KpyHC9Pi
         +iaw==
X-Gm-Message-State: APjAAAVJaNfF4hFFSEpv99VaBh9qM5x78jobAZDgYwshByzuKJvjJYBY
        ATTcE7z+FJtDUWKJlA7eDAc=
X-Google-Smtp-Source: APXvYqzKLmAcqVRHpCM2a51XNFnNEeFgQTG3TSdXnz+WXgyrPPBY6pL78aT2ruYXNG6twYyVG1W0AA==
X-Received: by 2002:a37:6fc4:: with SMTP id k187mr242305qkc.21.1579815225539;
        Thu, 23 Jan 2020 13:33:45 -0800 (PST)
Received: from [10.10.4.153] ([38.88.53.90])
        by smtp.googlemail.com with ESMTPSA id f5sm1607289qke.109.2020.01.23.13.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 13:33:44 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
Date:   Thu, 23 Jan 2020 14:33:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87tv4m9zio.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 4:35 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@kernel.org> writes:
> 
>> From: David Ahern <dahern@digitalocean.com>
>>
>> Add IFLA_XDP_EGRESS to if_link.h uapi to handle an XDP program attached
>> to the egress path of a device. Add rtnl_xdp_egress_fill and helpers as
>> the egress counterpart to the existing rtnl_xdp_fill. The expectation
>> is that going forward egress path will acquire the various levels of
>> attach - generic, driver and hardware.
> 
> How would a 'hardware' attach work for this? As I said in my reply to
> the previous patch, isn't this explicitly for emulating XDP on the other
> end of a point-to-point link? How would that work with offloaded
> programs?
> 
> -Toke
> 

Nothing about this patch set is limited to point-to-point links.
