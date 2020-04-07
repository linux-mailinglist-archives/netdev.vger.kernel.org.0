Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D111A12C4
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 19:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDGRe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 13:34:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35282 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGRe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 13:34:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id a13so1125640pfa.2;
        Tue, 07 Apr 2020 10:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VfOmombnx46eshTSKRK9pRfZX76vCXDPnZXls0b51W4=;
        b=Hddv0C4kDCfZnk2aC1nGmIdqB+XhZGb5+u8cg0skh3IhZHszlQML6SsJmVOEPvlzC3
         cvG9y9qFXCjYTfuFZ4yHxHFZ0F0DUaJ2HKJUaVMabXAKfm3iOJLjjtr+Oo8eo5GFPn9F
         5bg8QwvETywP8lpmMV9Mx5UMk20o+ehbDlCIWALsBQzksEO9mP9GCkWK5SoKsYht2Nqo
         muzRNQFCLmTZP6rmVDo0FO9BsUb+PPVYF8kwWycdAEkm5c3ASxYS7m0A1KnWM7bnwgXN
         s2NinSYKFQ1iHmZQwQxOfBPVfIL+ZJf/yiGP/SDZZHuC839oDrSeCSdFEPLaDUikmy8W
         wHaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VfOmombnx46eshTSKRK9pRfZX76vCXDPnZXls0b51W4=;
        b=XpGrK5CTOWbNxaNHXushRxdUs/WWzunt1DqV4HKokUnz3cDVd7BUUKxNZokdtbu2xu
         pllq4sYOje7luj4KELBy2/gniPfxfHNvNcSTG9q9LrzQqOYqCRcyfQ0rDQh1VXXPVoXu
         LO6esU65RCmusn/d6dOoDiF/2KdHXuLD2g4pkU73ZXRvCkQZBL0RKV9J8eMTrpQiYMQt
         /3XLrf8XmAAquSfWJsTB5NCwAlRyDhTIr92Ghcqtud9ehS1irbox+nkzfba8CE1pRe2o
         MrGMknxdmaZr1MHs7PCCuNOl9ZKmns1NlmwYggsDc2kexkzxXUAhJH8yYgTtFfzNqhCg
         ZqrQ==
X-Gm-Message-State: AGi0PuYCdF35AJm/Ba8FteXn7p3W3w8RDMNnT+9FMCa3rG9Qdkx7iPmp
        wdOMC7dckHeavtqJZw2Bowaax2b1
X-Google-Smtp-Source: APiQypIa74zR0qmYTbKig2FWmaxACiZBiwVwKrRADP9Gpene7wmvTJ8v7M8WNDzgMsj7vfTCmBl1pg==
X-Received: by 2002:a63:741b:: with SMTP id p27mr3114156pgc.68.1586280866998;
        Tue, 07 Apr 2020 10:34:26 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:863d])
        by smtp.gmail.com with ESMTPSA id x68sm13108858pfb.5.2020.04.07.10.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 10:34:25 -0700 (PDT)
Date:   Tue, 7 Apr 2020 10:34:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Matt Cover <werekraken@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team@fb.com
Subject: Re: unstable bpf helpers proposal. Was: [PATCH bpf-next v2 1/2] bpf:
 add bpf_ct_lookup_{tcp,udp}() helpers
Message-ID: <20200407173423.jh2ed3enaohfo5g2@ast-mbp.dhcp.thefacebook.com>
References: <20200121202038.26490-1-matthew.cover@stackpath.com>
 <CAGyo_hpVm7q3ghW+je23xs3ja_COP_BMZoE_=phwGRzjSTih8w@mail.gmail.com>
 <CAOftzPi74gg=g8VK-43KmA7qqpiSYnJVoYUFDtPDwum10KHc2Q@mail.gmail.com>
 <CAGyo_hprQRLLUUnt9G4SJnbgLSdN=HTDDGFBsPYMDC5bGmTPYA@mail.gmail.com>
 <20200130215330.f3unziderf5rlipf@ast-mbp>
 <CAGyo_hrYhwzVRcyN22j_4pBAcVGaazSu2xQFHT_DYpFeHdUjyA@mail.gmail.com>
 <20200220044505.bpfvdrcmc27ik2jp@ast-mbp>
 <CAGyo_hrcibFyz=b=+y=yO_yapw=TbtbO8d1vGPSLpTU0Y2gzBw@mail.gmail.com>
 <20200407030303.ffs7xxruuktss5fs@ast-mbp.dhcp.thefacebook.com>
 <CAGyo_hrYYYN6EXnbocauMo52pF52fAQwiJbDVZwH4NG3UC5anQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGyo_hrYYYN6EXnbocauMo52pF52fAQwiJbDVZwH4NG3UC5anQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 10:28:13PM -0700, Matt Cover wrote:
> >
> > I don't see why 1 and 2 are necessary.
> > What is the value of true export_symbol here?
> 
> Hmm... I was under the impression that these functions had to be
> exported to be eligible for BTF. Perhaps I'm misunderstanding this
> dwaves commit:
> 
>   3c5f2a224aa1 ("btf_encoder: Preserve and encode exported functions
> as BTF_KIND_FUNC")
> 
> Looking briefly I can see that the functions in symvers and BTF are
> not an exact match. Does "exported functions" in the above commit
> message not mean "exported symbols"?

Yeah. That pahole's commit log is confusing.
It meant to say that all of exported symbols will be in BTF
along with all other global functions.
$ bpftool btf dump file ./bld_x64/vmlinux|grep __icmp_send
[71784] FUNC '__icmp_send' type_id=71783
$ bpftool btf dump file ./bld_x64/vmlinux|grep bpf_prog_alloc_no_stats
[17945] FUNC 'bpf_prog_alloc_no_stats' type_id=17943
First one is exported. Second is a simple global.
There is no difference between them from BTF pov.

pahole can be improved too.
If it turns out that certain static functions has to be in BTF
we can easily make it so.

> >
> > crc don't add any additional value on top of BTF. BTF types has to match exactly.
> > It's like C compiler checking that you can call a function with correct proto.
> 
> I can see that for the verifier BTF is much superior to crc. The
> safety of the program is not improved by the crc. I was simply
> thinking the crc could be used in struct variant selection instead
> of kernel version. In some environments this could be useful since
> distros often backport patches while leaving version old (often
> meaning a second distro-specific version must also be considered).

The kernel version should not be used in any kind of logic. Lots of folks
backport bpf patches to older versions of the kernel. The kernel version is
meaningless form bpf pov. We even removed kernel_version check from kprobe
programs, because it was useless. vmlinux BTF is a complete description of the
running kernel. It's the one that the verifier is using to do it safety checks.
