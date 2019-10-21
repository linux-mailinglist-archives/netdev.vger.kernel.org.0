Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54697DF791
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 23:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbfJUVni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 17:43:38 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42046 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730387AbfJUVng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 17:43:36 -0400
Received: by mail-lj1-f193.google.com with SMTP id u4so810290ljj.9
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 14:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3yz2dDg8kGKHe/KdmAKuB5h5HlI7viBlMhf6Er7BmAc=;
        b=M6jMXJhStx2J2smoc8sUROKqUvSiOe5Uxj5ERKAEVzwJYa5cP7pIzHeAKS7YO9gLc3
         MaqfYdj0WEeUXTOpSlmDKllBFzoTaJ6P668rEXvy94XLvzpjGE2cBhhQNcEk4Kdyw0Mt
         Kg0M+iRdEMz8wYYxs7LWbQtC8vkFING0gIIVNLfSu8fG7ZMZScQhvsSVpFENGRf6RbaX
         cR2F7O+EjUPP3v7Q8Hgndvid1seaw0TjAQHGIuB2FoYVwHLg8yWM0vZNPM+pgPbEFQdP
         0l3L+5cxJqH5JpmWETeZzb8mkstpAWFkBEQ8QVSR4oOZ5cVX30LKSvSFOvgN6e52scUf
         +Qqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3yz2dDg8kGKHe/KdmAKuB5h5HlI7viBlMhf6Er7BmAc=;
        b=cYnIaLbXXtGXQIK4QYSBL4yiWg8Iv3lo38IaYutnBB1UNiZHn+4vtdy6KUvUbHbOuk
         CAhdIR6EyKPRbAap2MqYuL9VKuWtaTJhU5JHTeHBmpVbdisWskfCuEDrtcoRZ5VnXC8m
         1A7Vf2fXwOneuXIg04fNsNJtwSXXIsTvjsqo19ts3+YHlJzZyKBDmKFvF5JVeplRCudk
         a8Jdt0Bb8504PrFkTj2jOsRhpFM4qHzE6B8c4dRBCaAnSAQyxDR1H/oJ2O6MwJSauCQ8
         MoZRlkvunKUG4UPZXKecYbq/e5oUTF4MqSSDXOjI2WwxQCIqDAvb3C3yOJyYNJoyy2vl
         w8PQ==
X-Gm-Message-State: APjAAAUGyy/KbHGFAuiMWZMvPya/af8LadAsBjJYH6y4p3LJVEJmpiS5
        quOyRE407K5XMrt7wFM2vAU6CCRjkoiC5rcoctfT
X-Google-Smtp-Source: APXvYqxUgm3nz/WJuxpRqi/1IdOlAjmH3+7y1lZ1RFxqYiIzBI4/RatsbfN1YCcMEpwspzpdbR1CFm/s2iPvH9CTx4Y=
X-Received: by 2002:a2e:1b52:: with SMTP id b79mr16459510ljb.225.1571694212743;
 Mon, 21 Oct 2019 14:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
 <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca> <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
 <20191021213824.6zti5ndxu7sqs772@madcap2.tricolour.ca>
In-Reply-To: <20191021213824.6zti5ndxu7sqs772@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 21 Oct 2019 17:43:21 -0400
Message-ID: <CAHC9VhRdNXsY4neJpSoNyJoAVEoiEc2oW5kSscF99tjmoQAxFA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 5:38 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-10-21 15:53, Paul Moore wrote:
> > On Fri, Oct 18, 2019 at 9:39 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2019-09-18 21:22, Richard Guy Briggs wrote:
> > > > Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
> > > > process in a non-init user namespace the capability to set audit
> > > > container identifiers.
> > > >
> > > > Use audit netlink message types AUDIT_GET_CAPCONTID 1027 and
> > > > AUDIT_SET_CAPCONTID 1028.  The message format includes the data
> > > > structure:
> > > > struct audit_capcontid_status {
> > > >         pid_t   pid;
> > > >         u32     enable;
> > > > };
> > >
> > > Paul, can I get a review of the general idea here to see if you're ok
> > > with this way of effectively extending CAP_AUDIT_CONTROL for the sake of
> > > setting contid from beyond the init user namespace where capable() can't
> > > reach and ns_capable() is meaningless for these purposes?
> >
> > I think my previous comment about having both the procfs and netlink
> > interfaces apply here.  I don't see why we need two different APIs at
> > the start; explain to me why procfs isn't sufficient.  If the argument
> > is simply the desire to avoid mounting procfs in the container, how
> > many container orchestrators can function today without a valid /proc?
>
> Ok, sorry, I meant to address that question from a previous patch
> comment at the same time.
>
> It was raised by Eric Biederman that the proc filesystem interface for
> audit had its limitations and he had suggested an audit netlink
> interface made more sense.

I'm sure you've got it handy, so I'm going to be lazy and ask: archive
pointer to Eric's comments?  Just a heads-up, I'm really *not* a fan
of using the netlink interface for this, so unless Eric presents a
super compelling reason for why we shouldn't use procfs I'm inclined
to stick with /proc.

> The intent was to switch to the audit netlink interface for contid,
> capcontid and to add the audit netlink interface for loginuid and
> sessionid while deprecating the proc interface for loginuid and
> sessionid.  This was alluded to in the cover letter, but not very clear,
> I'm afraid.  I have patches to remove the contid and loginuid/sessionid
> interfaces in another tree which is why I had forgotten to outline that
> plan more explicitly in the cover letter.

-- 
paul moore
www.paul-moore.com
