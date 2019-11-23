Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD056107FC4
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 19:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKWSKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 13:10:10 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38034 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfKWSKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 13:10:10 -0500
Received: by mail-qt1-f196.google.com with SMTP id 14so11992173qtf.5
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 10:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=lnx7NGp0HPv50/J8yjWAmTL4lxVLF4VPnEAlaw3sOCk=;
        b=ukcsf3PRBlCg2QC2W0GNxWc3wWMDNMIIoIpuu6bz3neC5ey2T7IM34hclRrql/jVtx
         pYjYqfOM8BA2DRc9coE6dgd56E91Tky33G+a+QJy4qkAb4w+Ga6kfY9g6Ml7jB17Gx5Q
         XfBSSCq+I5smzTZXBnJ+D78s86QyE33T6/zWY5rb0EvFycgt3581caMs82EJ1DyQPqrB
         0Sxaw+oD2Qo9ehtNp2K4MOXoCr/N2t9uJrdwt9XsYEcCkTd4fiWESypX8EIbxYdSkeqL
         buH/2qykGuB0ga/FidtdNT94ZlHbWacvWLSWsLcdGnzTsOuCxQL4ta4BoOT6r5w3KE47
         hxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lnx7NGp0HPv50/J8yjWAmTL4lxVLF4VPnEAlaw3sOCk=;
        b=HWxXdfJYJ10P3o5ymS3AqqgELXaARKMZZsExSiH63xc1D40SFwdF2mTQ9NPUQZ8Zvh
         /jEhIfIs+ADKNrudhkv+eP4eJ+cTz3H9IbYlBytuPtSJvL4/r0HytVO+IETQdBBdsBu/
         IdWpG0pM0yY8oSWtjiRgF5luhRG3HdcLbBi9CKKzGBC2PVfjhhcOBW23n8y8eewkj1RM
         qTgyMiWpk4X/WVyncRXlViU8eVJ0b5iesmDS6142g8SSMa2Y7mWJXu8mZkBtJBIiOqiA
         Ik5JlUcm9FcRUdMqTXrP96Vdp6LYtJEtNAACJgMJuKB9hjnTXym1YyDAe4W+FxJ7voO5
         7RYw==
X-Gm-Message-State: APjAAAXSOBYnxb4rr5v7X7ftqTODkkzVKmEadVK4JDoU4eV+rKbbzn0+
        M73QmxMItquqIkV+e6q3Rl1rhKS2
X-Google-Smtp-Source: APXvYqy2e1Iv0+Wcmk5uiKtjK7TPuCBIINzjoV0PYJCiC4dSiBkd2ltD2Aq1wCbBZbra7tV/UktkDQ==
X-Received: by 2002:ac8:474b:: with SMTP id k11mr20835982qtp.152.1574532608567;
        Sat, 23 Nov 2019 10:10:08 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:c435:ff27:4396:2f9f])
        by smtp.googlemail.com with ESMTPSA id q34sm950477qte.50.2019.11.23.10.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 10:10:07 -0800 (PST)
Subject: Re: VRF and/or cgroups problem on Fedora-30, 5.2.21+ kernel
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com>
 <850a6d4e-3a67-a389-04a0-87032e0683d8@gmail.com>
 <213aa1d3-5df9-0337-c583-34f3de5f1582@candelatech.com>
 <8ae551e1-5c2e-6a95-b4d1-3301c5173171@gmail.com>
 <ffbeb74f-09d5-e854-190e-5362cc703a10@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fb74534d-f5e8-7b9b-b8c0-b6d6e718a275@gmail.com>
Date:   Sat, 23 Nov 2019 11:10:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <ffbeb74f-09d5-e854-190e-5362cc703a10@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 5:23 PM, Ben Greear wrote:
>>
> 
> Setting:  ulimit -l 1024
> 
> 'fixed' the problem.
> 
> I'd rather waste a bit of memory and not have any of my users hit such
> an esoteric
> bug, so I'll set it to at least 1024 going forward.

agreed.

> 
> Would large numbers of vrf and/or network devices mean you need more
> locked memory?

I have seen this problem way too much, but not taken the time to track
down all of the locked memory use. A rough estimate is that each 'ip vrf
exec' uses 1 page (4kB) of locked memory until the command exits. If you
use that as a rule you would be on the high end. Commands in the same
cgroup hierarchy should all be using the same program.

> 
> And surely 'ip' could output a better error than just 'permission
> denied' for
> this error case?  Or even something that would show up in dmesg to give
> a clue?

That error comes from the bpf syscall:

bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_CGROUP_SOCK, insn_cnt=6,
insns=0x7ffc8e5d1e00, license="GPL", log_level=1, log_size=262144,
log_buf="", kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0,
prog_name="", prog_ifindex=0,
expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0,
func_info_rec_size=0, func_info=NULL, func_info_cnt=0,
line_info_rec_size=0, line_info=NULL, line_info_cnt=0}, 112) = -1 EPERM
(Operation not permitted)

Yes it is odd and unhelpful for a memory limit to cause the failure and
then return EPERM.
