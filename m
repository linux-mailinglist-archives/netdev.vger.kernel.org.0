Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4363A3013
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFJQHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:07:52 -0400
Received: from mail-oo1-f43.google.com ([209.85.161.43]:42694 "EHLO
        mail-oo1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhFJQHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:07:51 -0400
Received: by mail-oo1-f43.google.com with SMTP id y18-20020a4ae7120000b02902496b7708cfso4062oou.9
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 09:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=kVGqpAL8u87a9dEz6rqHJJVepezU3tGlXLFcyhVYGuY=;
        b=LgxhvNw3A/GF1/H8ZeC5dGQwGmkpG8tccJYzLzAmCWQrgSPsbOWwwoIc+1sMBhIKSi
         JPEA7OiDSRR5rUW7AqwTyvdpbdOx/A4jxAp9M+Cvhiz0popoYdCjiMCxUJ0j5szU0VIy
         fYxvxZR8iSB7G4D6qIiKRn4Hh3YKUN15gYNf9zk4o0BGc3h6S11BLPFIMmAiSTijzzW+
         HRnTK4HMkmu7KfzPsh8BzmpsecFsehJVH2cAPVP1UswM84gNE3+Jqp1oQ712Futcisjv
         Vdtmg0zGErjGFEwWckeG858tfiI1js2P3BpXKlZW2qMymFCcf1pjc/iVz7/5WYARCyqn
         vTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=kVGqpAL8u87a9dEz6rqHJJVepezU3tGlXLFcyhVYGuY=;
        b=K3YTwB4GKydwZeuidSQBvOKStGUllpBz9yrDVP2n1s+KBpDg0wRHjkA0bmBH0cZms8
         VX2DRvCuwmLTFZ3RRfrrv6CYAGTI1GjYXEXwYDmbcUoMhOIupUzv9knuyQuPFscM9BUU
         J/OlJmbohCVBbdus1LDSs7NvZ2NhtwDIII2EIcQTpaS82P3Q75Zvs8VqiGy6N5dDySvg
         eisZSvdzOPU1rA1e3Udm+X9istQ8MBlS+48CN+2lyRwfuomqhtKWPyCdJQLyJrbUdHIF
         c4Vfzg29ZpZoTzx7GkbvfFwrZ8FWSfdK8byhDdBr1ngh9J+pcKE7pBPNdC6YPQIsTyl/
         zXZw==
X-Gm-Message-State: AOAM530g8t3gW+rRAvj7UB+bWp8cjRkXbCIEFeegBCWqr3Fasj3RaI1c
        /8W7twjPAl6g8AQr9IR45QQsvy+CvVcdiKKkGynghZu4
X-Google-Smtp-Source: ABdhPJxsftynEms0C+SKmaFOYgzLv/xbmTmrHDFbIc4iKlMr1XBh5xQv2lEiRuggMmYUb1kfnOEfbKbHsupAsgCBVzA=
X-Received: by 2002:a4a:ba87:: with SMTP id d7mr2914002oop.6.1623341081432;
 Thu, 10 Jun 2021 09:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAKfDRXgBcW4Ps57Bfj7y=NwDX3K-vB8Hpa-ykJ0BOnOdUfdcmg@mail.gmail.com>
In-Reply-To: <CAKfDRXgBcW4Ps57Bfj7y=NwDX3K-vB8Hpa-ykJ0BOnOdUfdcmg@mail.gmail.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Thu, 10 Jun 2021 18:04:30 +0200
Message-ID: <CAKfDRXge7RmsTx2Xh6BFwX+qObZXtukkm0LKkZQo+z9vubpybw@mail.gmail.com>
Subject: Re: Kernel oops when using rmnet together with qmi_wwan on kernel 5.4
To:     Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org, stranche@codeaurora.org,
        sharathv@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jun 9, 2021 at 8:39 PM Kristian Evensen
<kristian.evensen@gmail.com> wrote:
> Does anyone have any idea about what could be wrong, where to look or
> how to fix the problem? Are there for example any related commits that
> I should backport to my 5.4 kernel?

I spent some more time looking into this problem today and I believe I
have figured out what goes wrong. Please note that my knowledge of the
network driver infrastructure is a bit limited, so please excuse any
mistakes :)

I started out by taking a closer look at the rmnet code, and I noticed
that rmnet calls consume_skb() when the processing of the aggregated
skb is done. Instrumenting the kernel revealed that the reference
count of the aggregated is one, so the skb will be freed inside
consume_skb(). I believe the call to consume_skb can cause problems
with usbnet, depending on the order of operations. The skb that is
passed to rmnet is owned by usbnet and is referenced after the
qmi_wwan rx_fixup-callback has been called.

In order to try to prove my theory, I modified qmi_wwan to clone the
skb inside qmi_wwan_rx_fixup (before the call to netif_rx()). When
cloning the skb, I am no longer able to trigger the crash. Without
cloning, the crash happens more or less instantaneously. I don't know
if my reasoning and fix makes sense, or if I have misunderstood
something or there is a better way to fix the problem? I also tried to
only call skb_get() but this did not help.

BR,
Kristian
