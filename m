Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7421039DBEB
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhFGMJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:09:51 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:41979 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhFGMJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 08:09:51 -0400
Received: by mail-pg1-f172.google.com with SMTP id r1so13635087pgk.8
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 05:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oySWjuX00iG0JfJzUXzKlyJetxcPmKf366838bUm5Rg=;
        b=UpBmWQRLe6JFE2S8G4OGu0YN1kLq1W3qSXuczk4PCC5QaLBGtwtX8xybNoRSnv0gOU
         NXch2EegBW4YWUzB/iEH2qn8yo9MmTTZWWZ5wimEo179T449eBh+IXHKWTv8SxgH3ja1
         Oj+IQctXfy5c2NGA+knFST0adlUjBORKRImhMJ7r2+fWlPrfwso765e2EcW07Vv2Xfw9
         OPn6Ixmc2sXnbWI2ucraPrA9t36UIFFMaZUp2Uv/yuZaeSIPguYNkzoJAPAKHYO6jVed
         lrcz9rOcqt6YCyoyj4bwFKcdxedh0HT1bqX0HK0O5nAA634qTQVnnORhDvwGnaEikSmV
         Io3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oySWjuX00iG0JfJzUXzKlyJetxcPmKf366838bUm5Rg=;
        b=Yz5VjPSjLx5Gd9ZTLnn9hDkog7TxgQjj0MyiAgQQIUpJYQs0Z1/EZ/ildQD9NBCmhe
         9hPzyQULZeZcqhUu9wRxpRl05TOwEc8TagEdhl/cVrpbDRV8L/EbRQhUwWez5t1RZ4Ea
         Ey0AYSt1+WvD2GkAZNueDI/SbI7WAzFJyk5w3zgXlvMeHXcl2gsVQYhCnZLN/XgTjWgI
         nbvUOhVtqQ5wkjvFCK20u866mUbZr25vCEwMbjxsnE/uxLUAO2A1PRUPVOkA4Fxn+nRv
         EHrDK89tfs5MwdZTygvjMxXpqNBHyyC/0xVJQts8Fax+6fQRRU6D7+cQgzu1ShLueYt7
         bEoA==
X-Gm-Message-State: AOAM533bvsT3IuX89zV4rJcM+azCdXK8J1aMwyRlh9riyTfVppfnlcHa
        h7a9nQuYPMG9PBE5XLv3BNQq9tjstO2jFW6lR3ZSlg==
X-Google-Smtp-Source: ABdhPJzkAJCfO9yVvT65VlXPaAEGniGvpLXC5En1kXF7+bjrFlu8Evpgv0TtfKBexeO5HftT67TA02y4L9dc3cBlSPE=
X-Received: by 2002:a63:1906:: with SMTP id z6mr17238719pgl.173.1623067619706;
 Mon, 07 Jun 2021 05:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <YLfL9Q+4860uqS8f@gerhold.net> <CAMZdPi9tcye-4P4i0uXZcECJ-Big5T11JdvdXW6k2mEEi9XwyA@mail.gmail.com>
 <YLtDB2Cz5ttewsFu@gerhold.net> <CAMZdPi_-Qa=JnThHs_h-144dAfSAjF5s+QdBawdXZ3kk8Mx8ng@mail.gmail.com>
 <YL364+xK3mE2FU8a@gerhold.net> <87sg1tvryx.fsf@toke.dk> <YL4GiEEcOQC2XrjP@gerhold.net>
In-Reply-To: <YL4GiEEcOQC2XrjP@gerhold.net>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 7 Jun 2021 14:16:10 +0200
Message-ID: <CAMZdPi-91y+t1bHb+6NY5Dh-xV_yvJTzG65efaSKzyTNsEGBvA@mail.gmail.com>
Subject: Re: [RFC] Integrate RPMSG/SMD into WWAN subsystem
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Setphan,

On Mon, 7 Jun 2021 at 13:44, Stephan Gerhold <stephan@gerhold.net> wrote:
>
> On Mon, Jun 07, 2021 at 01:23:18PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > Stephan Gerhold <stephan@gerhold.net> writes:
> > > On Mon, Jun 07, 2021 at 11:27:07AM +0200, Loic Poulain wrote:
> > >> On Sat, 5 Jun 2021 at 11:25, Stephan Gerhold <stephan@gerhold.net> w=
rote:
> > >> > On Fri, Jun 04, 2021 at 11:11:45PM +0200, Loic Poulain wrote:
> > >> > > On Wed, 2 Jun 2021 at 20:20, Stephan Gerhold <stephan@gerhold.ne=
t> wrote:
> > >> > > > I've been thinking about creating some sort of "RPMSG" driver =
for the
> > >> > > > new WWAN subsystem; this would be used as a QMI/AT channel to =
the
> > >> > > > integrated modem on some older Qualcomm SoCs such as MSM8916 a=
nd MSM8974.
> > >> > > >
> > >> > > > It's easy to confuse all the different approaches that Qualcom=
m has to
> > >> > > > talk to their modems, so I will first try to briefly give an o=
verview
> > >> > > > about those that I'm familiar with:
> > >> > > >
> > >> > > > ---
> > >> > > > There is USB and MHI that are mainly used to talk to "external=
" modems.
> > >> > > >
> > >> > > > For the integrated modems in many Qualcomm SoCs there is typic=
ally
> > >> > > > a separate control and data path. They are not really related =
to each
> > >> > > > other (e.g. currently no common parent device in sysfs).
> > >> > > >
> > >> > > > For the data path (network interface) there is "IPA" (drivers/=
net/ipa)
> > >> > > > on newer SoCs or "BAM-DMUX" on some older SoCs (e.g. MSM8916/M=
SM8974).
> > >> > > > I have a driver for BAM-DMUX that I hope to finish up and subm=
it soon.
> > >> > > >
> > >> > > > The connection is set up via QMI. The messages are either sent=
 via
> > >> > > > a shared RPMSG channel (net/qrtr sockets in Linux) or via stan=
dalone
> > >> > > > SMD/RPMSG channels (e.g. "DATA5_CNTL" for QMI and "DATA1" for =
AT).
> > >> > > >
> > >> > > > This gives a lot of possible combinations like BAM-DMUX+RPMSG
> > >> > > > (MSM8916, MSM8974), or IPA+QRTR (SDM845) but also other funny
> > >> > > > combinations like IPA+RPMSG (MSM8994) or BAM-DMUX+QRTR (MSM893=
7).
> > >> > > >
> > >> > > > Simply put, supporting all these in userspace like ModemManage=
r
> > >> > > > is a mess (Aleksander can probably confirm).
> > >> > > > It would be nice if this could be simplified through the WWAN =
subsystem.
> > >> > > >
> > >> > > > It's not clear to me if or how well QRTR sockets can be mapped=
 to a char
> > >> > > > device for the WWAN subsystem, so for now I'm trying to focus =
on the
> > >> > > > standalone RPMSG approach (for MSM8916, MSM8974, ...).
> > >> > > > ---
> > >> > > >
> > >> > > > Currently ModemManager uses the RPMSG channels via the rpmsg-c=
hardev
> > >> > > > (drivers/rpmsg/rpmsg_char.c). It wasn't my idea to use it like=
 this,
> > >> > > > I just took that over from someone else. Realistically speakin=
g, the
> > >> > > > current approach isn't too different from the UCI "backdoor in=
terface"
> > >> > > > approach that was rejected for MHI...
> > >> > > >
> > >> > > > I kind of expected that I can just trivially copy some code fr=
om
> > >> > > > rpmsg_char.c into a WWAN driver since they both end up as a si=
mple char
> > >> > > > device. But it looks like the abstractions in wwan_core are ki=
nd of
> > >> > > > getting in the way here... As far as I can tell, they don't re=
ally fit
> > >> > > > together with the RPMSG interface.
> > >> > > >
> > >> > > > For example there is rpmsg_send(...) (blocking) and rpmsg_trys=
end(...)
> > >> > > > (non-blocking) and even a rpmsg_poll(...) [1] but I don't see =
a way to
> > >> > > > get notified when the TX queue is full or no longer full so I =
can call
> > >> > > > wwan_port_txon/off().
> > >> > > >
> > >> > > > Any suggestions or other thoughts?
> > >> > >
> > >> > > It would be indeed nice to get this in the WWAN framework.
> > >> > > I don't know much about rpmsg but I think it is straightforward =
for
> > >> > > the RX path, the ept_cb can simply forward the buffers to
> > >> > > wwan_port_rx.
> > >> >
> > >> > Right, that part should be straightforward.
> > >> >
> > >> > > For tx, simply call rpmsg_trysend() in the wwan tx
> > >> > > callback and don't use the txon/off helpers. In short, keep it s=
imple
> > >> > > and check if you observe any issues.
> > >> > >
> > >> >
> > >> > I'm not sure that's a good idea. This sounds like exactly the kind=
 of
> > >> > thing that might explode later just because I don't manage to get =
the
> > >> > TX queue full in my tests. In that case, writing to the WWAN char =
dev
> > >> > would not block, even if O_NONBLOCK is not set.
> > >>
> > >> Right, if you think it could be a problem, you can always implement =
a
> > >> more complex solution like calling rpmsg_send from a
> > >> workqueue/kthread, and only re-enable tx once rpmsg_send returns.
> > >>
> > >
> > > I did run into trouble when I tried to stream lots of data into the W=
WAN
> > > char device (e.g. using dd). However, in practice (with ModemManager)
> > > I did not manage to cause such issues yet. Personally, I think it's
> > > something we should get right, just to avoid trouble later
> > > (like "modem suddenly stops working").
> > >
> > > Right now I extended the WWAN port ops a bit so I tells me if the wri=
te
> > > should be non-blocking or blocking and so I can call rpmsg_poll(...).

OK, but note that poll seems to be an optional rpmsg ops, rpmsg_poll
can be a no-op and so would not guarantee that EPOLL_OUT will ever be
set.


Loic
