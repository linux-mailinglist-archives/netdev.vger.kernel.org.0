Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B6439DCE9
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhFGMu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:50:58 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:18208 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhFGMu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 08:50:57 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623070138; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=E26R7pk8r8OdbRWXephuuQYBXQ1cnrrrx1evfW78ZvpO1LwwQZ7n+QKzD9XdwxdHlK
    6X8h401pivpHVkabGLjCpT8fEd4ezTo4vBFb9XOQM9rOSzNC81C/Ukwhj4YGnwvKJ5Ft
    iwWZNGmIq2BxOWMkGgA2QLgIjZoKKIewkpdLR29d0A7E2jzk5vuej1UHPLHfGC1NsOxn
    KalwNWYXMwRJw+Q5xQQAU6MrAMKsdSaDnp962ggG93+NNuQKpK5xAGDQdCU8i/ldYXLs
    OE+NdF94N5MgOIoI1EaHYy4sdQ7+LtZteeo3FV92HjQmxGdrMx/BdoSgyVScCvb/GM7C
    Dw4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623070138;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=+SU65bGHAWVzzLktQHmvLbpL6Os1Tep8tLAd0BZJBW8=;
    b=MbeOQ67ftzk9RsFgSJ8e/vwT49bCrWTTd96teRmQu1crgOcLKhBVxPFUSFOaY4cW1G
    2hI0mCuZbJ6MBAvetw4Tu7l0Ep49DwcYJPZm8UC4TYTwgVbVf9XU1ihf4tL11vj14QRU
    ShH19KH9fxweFOPmT06zI3artkhLenmx8XT8f7glPTYZ46BwzY0102Ci1TFovgm3Mo6I
    an9BMpoxL6qz+/zQLFuE13sJhmtEC8XYaBsnIsXB4nLCz0YurGd9BaNgojB2lvT2Sj39
    SLrlFcHeo7Sw0I4Tlv+qTGLnd9UDttFvc5uk9lbqijIuZCsWomhHOddXn2dkm23RCCTy
    89KA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623070138;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=+SU65bGHAWVzzLktQHmvLbpL6Os1Tep8tLAd0BZJBW8=;
    b=lIFYLpwHiTfz+yI4tqjlQmoZigJN4H4+O8S8j4WQ1mhVU5G3iIMDPlGkfghosVmo+z
    GmMEvFc1OzbULmi6F3etwwd9VA0xlxtPG/qFfeI5wda+YTg5ntvbCzjFyFNb53F1WwZg
    rL37iymiwD6hBSKq70bGYh5kzETMewOYQCLBcKzQPg7coNjJsIDTc7loYvm5ZA8kHFIc
    RRKUSFpGyPv3nOF9biMxqhXwE5M7ewyWdnEO3buwqsrmdAzCe2EoQbbjFOhsrJNePaPO
    Z83r+ur/tBroj7dnCxxDwNayEaoU6UwOGisms6Jh787SQ0Hjop5FY+KSbipDHgw6uNfR
    OTIA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j7Ic/BBg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id y01375x57CmvUiI
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 7 Jun 2021 14:48:57 +0200 (CEST)
Date:   Mon, 7 Jun 2021 14:48:47 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [RFC] Integrate RPMSG/SMD into WWAN subsystem
Message-ID: <YL4Vr0mhiOJp8jkT@gerhold.net>
References: <YLfL9Q+4860uqS8f@gerhold.net>
 <CAMZdPi9tcye-4P4i0uXZcECJ-Big5T11JdvdXW6k2mEEi9XwyA@mail.gmail.com>
 <YLtDB2Cz5ttewsFu@gerhold.net>
 <CAMZdPi_-Qa=JnThHs_h-144dAfSAjF5s+QdBawdXZ3kk8Mx8ng@mail.gmail.com>
 <YL364+xK3mE2FU8a@gerhold.net>
 <87sg1tvryx.fsf@toke.dk>
 <YL4GiEEcOQC2XrjP@gerhold.net>
 <CAMZdPi-91y+t1bHb+6NY5Dh-xV_yvJTzG65efaSKzyTNsEGBvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMZdPi-91y+t1bHb+6NY5Dh-xV_yvJTzG65efaSKzyTNsEGBvA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jun 07, 2021 at 02:16:10PM +0200, Loic Poulain wrote:
> On Mon, 7 Jun 2021 at 13:44, Stephan Gerhold <stephan@gerhold.net> wrote:
> >
> > On Mon, Jun 07, 2021 at 01:23:18PM +0200, Toke Høiland-Jørgensen wrote:
> > > Stephan Gerhold <stephan@gerhold.net> writes:
> > > > On Mon, Jun 07, 2021 at 11:27:07AM +0200, Loic Poulain wrote:
> > > >> On Sat, 5 Jun 2021 at 11:25, Stephan Gerhold <stephan@gerhold.net> wrote:
> > > >> > On Fri, Jun 04, 2021 at 11:11:45PM +0200, Loic Poulain wrote:
> > > >> > > On Wed, 2 Jun 2021 at 20:20, Stephan Gerhold <stephan@gerhold.net> wrote:
> > > >> > > > I've been thinking about creating some sort of "RPMSG" driver for the
> > > >> > > > new WWAN subsystem; this would be used as a QMI/AT channel to the
> > > >> > > > integrated modem on some older Qualcomm SoCs such as MSM8916 and MSM8974.
> > > >> > > >
> > > >> > > > It's easy to confuse all the different approaches that Qualcomm has to
> > > >> > > > talk to their modems, so I will first try to briefly give an overview
> > > >> > > > about those that I'm familiar with:
> > > >> > > >
> > > >> > > > ---
> > > >> > > > There is USB and MHI that are mainly used to talk to "external" modems.
> > > >> > > >
> > > >> > > > For the integrated modems in many Qualcomm SoCs there is typically
> > > >> > > > a separate control and data path. They are not really related to each
> > > >> > > > other (e.g. currently no common parent device in sysfs).
> > > >> > > >
> > > >> > > > For the data path (network interface) there is "IPA" (drivers/net/ipa)
> > > >> > > > on newer SoCs or "BAM-DMUX" on some older SoCs (e.g. MSM8916/MSM8974).
> > > >> > > > I have a driver for BAM-DMUX that I hope to finish up and submit soon.
> > > >> > > >
> > > >> > > > The connection is set up via QMI. The messages are either sent via
> > > >> > > > a shared RPMSG channel (net/qrtr sockets in Linux) or via standalone
> > > >> > > > SMD/RPMSG channels (e.g. "DATA5_CNTL" for QMI and "DATA1" for AT).
> > > >> > > >
> > > >> > > > This gives a lot of possible combinations like BAM-DMUX+RPMSG
> > > >> > > > (MSM8916, MSM8974), or IPA+QRTR (SDM845) but also other funny
> > > >> > > > combinations like IPA+RPMSG (MSM8994) or BAM-DMUX+QRTR (MSM8937).
> > > >> > > >
> > > >> > > > Simply put, supporting all these in userspace like ModemManager
> > > >> > > > is a mess (Aleksander can probably confirm).
> > > >> > > > It would be nice if this could be simplified through the WWAN subsystem.
> > > >> > > >
> > > >> > > > It's not clear to me if or how well QRTR sockets can be mapped to a char
> > > >> > > > device for the WWAN subsystem, so for now I'm trying to focus on the
> > > >> > > > standalone RPMSG approach (for MSM8916, MSM8974, ...).
> > > >> > > > ---
> > > >> > > >
> > > >> > > > Currently ModemManager uses the RPMSG channels via the rpmsg-chardev
> > > >> > > > (drivers/rpmsg/rpmsg_char.c). It wasn't my idea to use it like this,
> > > >> > > > I just took that over from someone else. Realistically speaking, the
> > > >> > > > current approach isn't too different from the UCI "backdoor interface"
> > > >> > > > approach that was rejected for MHI...
> > > >> > > >
> > > >> > > > I kind of expected that I can just trivially copy some code from
> > > >> > > > rpmsg_char.c into a WWAN driver since they both end up as a simple char
> > > >> > > > device. But it looks like the abstractions in wwan_core are kind of
> > > >> > > > getting in the way here... As far as I can tell, they don't really fit
> > > >> > > > together with the RPMSG interface.
> > > >> > > >
> > > >> > > > For example there is rpmsg_send(...) (blocking) and rpmsg_trysend(...)
> > > >> > > > (non-blocking) and even a rpmsg_poll(...) [1] but I don't see a way to
> > > >> > > > get notified when the TX queue is full or no longer full so I can call
> > > >> > > > wwan_port_txon/off().
> > > >> > > >
> > > >> > > > Any suggestions or other thoughts?
> > > >> > >
> > > >> > > It would be indeed nice to get this in the WWAN framework.
> > > >> > > I don't know much about rpmsg but I think it is straightforward for
> > > >> > > the RX path, the ept_cb can simply forward the buffers to
> > > >> > > wwan_port_rx.
> > > >> >
> > > >> > Right, that part should be straightforward.
> > > >> >
> > > >> > > For tx, simply call rpmsg_trysend() in the wwan tx
> > > >> > > callback and don't use the txon/off helpers. In short, keep it simple
> > > >> > > and check if you observe any issues.
> > > >> > >
> > > >> >
> > > >> > I'm not sure that's a good idea. This sounds like exactly the kind of
> > > >> > thing that might explode later just because I don't manage to get the
> > > >> > TX queue full in my tests. In that case, writing to the WWAN char dev
> > > >> > would not block, even if O_NONBLOCK is not set.
> > > >>
> > > >> Right, if you think it could be a problem, you can always implement a
> > > >> more complex solution like calling rpmsg_send from a
> > > >> workqueue/kthread, and only re-enable tx once rpmsg_send returns.
> > > >>
> > > >
> > > > I did run into trouble when I tried to stream lots of data into the WWAN
> > > > char device (e.g. using dd). However, in practice (with ModemManager)
> > > > I did not manage to cause such issues yet. Personally, I think it's
> > > > something we should get right, just to avoid trouble later
> > > > (like "modem suddenly stops working").
> > > >
> > > > Right now I extended the WWAN port ops a bit so I tells me if the write
> > > > should be non-blocking or blocking and so I can call rpmsg_poll(...).
> 
> OK, but note that poll seems to be an optional rpmsg ops, rpmsg_poll
> can be a no-op and so would not guarantee that EPOLL_OUT will ever be
> set.
> 

Wouldn't that be more a limitation of the driver that provides the rpmsg
ops then? If rpmsg_send(...) may block, it should also be possible to
implement rpmsg_poll(...). Right now my implementation basically behaves
mostly like the existing rpmsg-char. That's what has been used on
several devices for more than a year and it works quite well.

Granted, so far testing was mostly done with the "qcom_smd" RPMSG driver
(which is likely going to be the primary use case for my driver for now).
This one also happens to be the only one that implements rpmsg_poll()
at the moment...

I asked some other people to test it for AT messages with "glink" on
newer Qualcomm SoCs and that doesn't work that well yet. However, as far
as I can tell most of the trouble seems to be caused by various strange
bugs in the "glink" driver.
(See drivers/rpmsg for the drivers I'm referring to...)

---

One of the main potential problems I see with some kind of workqueue
approach is that all writes would seemingly succeed for the client.
When the extra thread is done with rpmsg_send(...) we will have already
returned from the char dev write(...) syscall, without a way to report
the error. Perhaps that's unlikely though and we don't need to worry
about that too much?

I'm not really sure which one of the solution is best at the end.
I think it doesn't make too much of a difference at the end, both can
work well and both have some advantages/disadvantages in certain fairly
unlikely situations.

Stephan
