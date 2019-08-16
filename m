Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C3D90A67
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 23:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbfHPVps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 17:45:48 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33722 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfHPVps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 17:45:48 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so3577990pgn.0;
        Fri, 16 Aug 2019 14:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=rTRJflC/XxBLRwk7ddMQbRUyGqdCMOTG2uddVwF5CRA=;
        b=jB1AnQawoQedqYKJq826OAR3SFlaaXgZH69A+tvDgt2K1K7zKQWqPwlEm6tMrAV8Yn
         Uuaamv2nEicce2W5ofEr1HDygvb2eDPhkiAn/ibfjRoYkUGKZWlgSmc0pdcPJzQko0eT
         9UPKrBtBdfESLvGp3y9NIBDG2+zyQRSHv7oC/V2653KPeANqBK2hSU/t/RVgAVVwm813
         gWN8FOGD0Ggb/F+moEvKQg3PiW+OkdJ6CY4/vRwT1LSYUJOJRtdoEciTJ3Ay7YpdIPXG
         tY1J1vKtR5CvapgSpVV3hi2KD9S7kzcbDb4p54EtpXQu9b4Kh62UYPt2IQzkdpfsFSJN
         fC+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=rTRJflC/XxBLRwk7ddMQbRUyGqdCMOTG2uddVwF5CRA=;
        b=l7EPdb1UTHEb4HGiOmHa6P4s+px5rO8YY1w9iWJ0cQI7MCev/dWlIwnn/cWLyzd2Du
         ZEfFSmjVD+biLBgm+FU+YQKnPr5EMAcvjEedVWujBmk12IVLNIUH9JOkVDbdZV9tyZqQ
         SSeusWMRMUW7U0ZUQ3IEBn9DWCMTdh+Wiisduk3zS3RLCt6ksnVjKQ5L0+as74/JYwv9
         8kDhEPRGsJ/GvWcXmMJ11PzM2NR1B6D725LDPCoMqvE4p1ic0VWhgb9HP4pjrk9R9o7O
         0E1kTxL0lrULAVvFCAdg+ndtKkQ39MIUSo3/J9Fte509Fs7yTcNN9S6iZolpq+qvvNow
         yzww==
X-Gm-Message-State: APjAAAWrvji3h8kLtudSmnFl7bGTlLpLGKDEi40t+jMGbm5QsqMnq5ns
        GD5bKbx/vk5D09X7f0wVEo8=
X-Google-Smtp-Source: APXvYqysgJqBQz521+pAW1NAwGoOd4PbNNpeVQ6+yfbXQ+uhgOU2OEgzlh4Xe/ovsCZpFHYNWfUaMw==
X-Received: by 2002:a65:638c:: with SMTP id h12mr9391815pgv.436.1565991947070;
        Fri, 16 Aug 2019 14:45:47 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::4e61])
        by smtp.gmail.com with ESMTPSA id d14sm3052732pjx.17.2019.08.16.14.45.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 14:45:46 -0700 (PDT)
Date:   Fri, 16 Aug 2019 14:45:44 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190816214542.inpt6p655whc2ejw@ast-mbp.dhcp.thefacebook.com>
References: <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <201908151203.FE87970@keescook>
 <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com>
 <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 05:54:59PM -0700, Andy Lutomirski wrote:
> 
> 
> > On Aug 15, 2019, at 4:46 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> 
> >> 
> >> I'm not sure why you draw the line for VMs -- they're just as buggy
> >> as anything else. Regardless, I reject this line of thinking: yes,
> >> all software is buggy, but that isn't a reason to give up.
> > 
> > hmm. are you saying you want kernel community to work towards
> > making containers (namespaces) being able to run arbitrary code
> > downloaded from the internet?
> 
> Yes.
> 
> As an example, Sandstorm uses a combination of namespaces (user, network, mount, ipc) and a moderately permissive seccomp policy to run arbitrary code. Not just little snippets, either — node.js, Mongo, MySQL, Meteor, and other fairly heavyweight stacks can all run under Sandstorm, with the whole stack (database engine binaries, etc) supplied by entirely untrusted customers.  During the time Sandstorm was under active development, I can recall *one* bug that would have allowed a sandbox escape. That’s a pretty good track record.  (Also, Meltdown and Spectre, sigh.)

exactly: "meltdown", "spectre", "sigh".
Side channels effectively stalled the work on secure containers.
And killed projects like sandstorm.
Why work on improving kaslr when there are several ways to
get kernel addresses through hw bugs? Patch mouse holes when roof is leaking ?
In case of unprivileged bpf I'm confident that all known holes are patched.
Until disclosures stop happening with the frequency they do now the time
of bpf developers is better spent on something other than unprivileged bpf.

> I’m suggesting that you engage the security community ...
> .. so that normal users can use bpf filtering

yes, but not soon. unfortunately.

