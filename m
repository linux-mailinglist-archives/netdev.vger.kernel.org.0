Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00334CAD89
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbfJCRpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:45:16 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44932 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730850AbfJCRpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:45:16 -0400
Received: by mail-io1-f65.google.com with SMTP id w12so7461894iol.11;
        Thu, 03 Oct 2019 10:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=bKVwErrHr2f+dxk4S22kvE7QuC7upJdZpAbg/+FysTY=;
        b=mg3SLrWnO+avkvKkTFSAkLhxomEVO1JddF76kPLQgqA2e3vmSgof5nmThCnaUkdmWi
         D1+2IHogtc0pT2P0Dde4nlyiG7qxYI7mJ6P3HQNi+l8tcagUcDgVTpGjTZTZF+O+y+O+
         oMUyJXntOYTMWHNw0297sinaMl9JDn48lyEYs7j+flsAG+w6XnLDNvHmzawC2jYPZbiG
         AVmvBwI5Qbv5MksRjvIJBznY/KD2NnOgP3hbGBs5pxAfuyxG2gbBSonpezjLtOjaGV2A
         I85g6q4btdskngADXO4CQAVa/qtKCdDOekbH9oCsj+UWYYIevMZWm9Fz+PN1gx/06SjX
         d+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=bKVwErrHr2f+dxk4S22kvE7QuC7upJdZpAbg/+FysTY=;
        b=sP0ju///8Pit7u4JxOWK5oP38QXSs/cSbslBU/hwhCwpRx3XX6/bnF8IdXNVjVUN0K
         XQfeCkRzvgVWrH1z8ujjkRKKhrdJ7WQIZjbPoBsnnPaZ7E2ZKJpcuWEpRdPYTho2STMG
         84EWW8PqCCd970bGkTA3LHGFzR6uhxlZT9+CYKLbyg4LobeIRsRcHGnNxLVlbj3mFN+9
         csoeNmgv7NmOhz6SSQtlbRBmsapyzzZdbolxoaovedY5t2LjMkXee2ndTERFPhUQV58e
         3FHKaSh/J++htzBUU3Ih9OPJ5dZm2kyZB+JXHTL5gIUamWFSMayHyTjT6Nhpw/So1oit
         4HDA==
X-Gm-Message-State: APjAAAXhGjygmMJc3p5QKf9+EwfS4DNHYZnM7OfHGx9zymtjDOgXLhhB
        vAyA/zPUA5uzmmP/CzAwbj+CRQeRLA0=
X-Google-Smtp-Source: APXvYqwfirEzf7045EMiY6mX2EQ/NgRPpctOg7M/DK1GviI2YEiv8gNYycIjcds2kHCPiaWV2lkBrA==
X-Received: by 2002:a92:8fcf:: with SMTP id r76mr11645616ilk.82.1570124714507;
        Thu, 03 Oct 2019 10:45:14 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m15sm1430802ilg.49.2019.10.03.10.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 10:45:13 -0700 (PDT)
Date:   Thu, 03 Oct 2019 10:45:06 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Message-ID: <5d9633a2de69c_55732aec43fe05c41@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzYbJZz7AwW_N=Q2b-V8ZQCJVTHeUaGo6Ji848aB_z8nXA@mail.gmail.com>
References: <20191002173357.253643-1-sdf@google.com>
 <20191002173357.253643-2-sdf@google.com>
 <CAEf4BzZuEChOL828F91wLxUr3h2yfAkZvhsyoSx18uSFSxOtqw@mail.gmail.com>
 <20191003014356.GC3223377@mini-arch>
 <CAEf4BzZnWkdFpSUsSBenDDfrvgjGvBxUnJmQRwb7xjNQBaKXdQ@mail.gmail.com>
 <20191003160137.GD3223377@mini-arch>
 <CAEf4BzYbJZz7AwW_N=Q2b-V8ZQCJVTHeUaGo6Ji848aB_z8nXA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Thu, Oct 3, 2019 at 9:01 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 10/02, Andrii Nakryiko wrote:
> > > On Wed, Oct 2, 2019 at 6:43 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > >
> > > > On 10/02, Andrii Nakryiko wrote:
> > > > > On Wed, Oct 2, 2019 at 10:35 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > > > >
> > > > > > Always use init_net flow dissector BPF program if it's attached and fall
> > > > > > back to the per-net namespace one. Also, deny installing new programs if
> > > > > > there is already one attached to the root namespace.
> > > > > > Users can still detach their BPF programs, but can't attach any
> > > > > > new ones (-EPERM).
> > >
> > > I find this quite confusing for users, honestly. If there is no root
> > > namespace dissector we'll successfully attach per-net ones and they
> > > will be working fine. That some process will attach root one and all
> > > the previously successfully working ones will suddenly "break" without
> > > users potentially not realizing why. I bet this will be hair-pulling
> > > investigation for someone. Furthermore, if root net dissector is
> > > already attached, all subsequent attachment will now start failing.
> > The idea is that if sysadmin decides to use system-wide dissector it would
> > be attached from the init scripts/systemd early in the boot process.
> > So the users in your example would always get EPERM/EBUSY/EXIST.
> > I don't really see a realistic use-case where root and non-root
> > namespaces attach/detach flow dissector programs at non-boot
> > time (or why non-root containers could have BPF dissector and root
> > could have C dissector; multi-nic machine?).
> >
> > But I totally see your point about confusion. See below.
> >
> > > I'm not sure what's the better behavior here is, but maybe at least
> > > forcibly detach already attached ones, so when someone goes and tries
> > > to investigate, they will see that their BPF program is not attached
> > > anymore. Printing dmesg warning would be hugely useful here as well.
> > We can do for_each_net and detach non-root ones; that sounds
> > feasible and may avoid the confusion (at least when you query
> > non-root ns to see if the prog is still there, you get a valid
> > indication that it's not).
> >
> > > Alternatively, if there is any per-net dissector attached, we might
> > > disallow root net dissector to be installed. Sort of "too late to the
> > > party" way, but at least not surprising to successfully installed
> > > dissectors.
> > We can do this as well.
> >
> > > Thoughts?
> > Let me try to implement both of your suggestions and see which one makes
> > more sense. I'm leaning towards the later (simple check to see if
> > any non-root ns has the prog attached).
> >
> > I'll follow up with a v2 if all goes well.
> 
> Thanks! I don't have strong opinion on either, see what makes most
> sense from an actual user perspective.


From my point of view the second option is better. The root namespace flow
dissector attach should always happen first before any other namespaces are
created. If any namespaces have already attached then just fail the root
namespace. 

Otherwise if you detach existing dissectors from a container these were
probably attached by the init container which might not be running anymore
and I have no easy way to learn/find out about this without creating another
container specifically to watch for this. If I'm relying on the dissector
for something now I can seemingly random errors. So its a bit ugly and I'll
probably just tell users to always attach the root namespace first to avoid
this headache. On the other side if the root namespace already has a
flow dissector attached and my init container fails its attach cmd I
can handle the error gracefully or even fail to launch the container with
a nice error message and the administrator can figure something out.
I'm always in favor of hard errors vs trying to guess what the right
choice is for any particular setup.

Also it seems to me just checking if anything is attached is going to make
the code simpler vs trying to detach things in all namespaces.
