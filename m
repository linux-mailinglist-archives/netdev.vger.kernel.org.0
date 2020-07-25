Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E2322D8BE
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 18:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgGYQjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 12:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgGYQjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 12:39:23 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB43C08C5C0
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 09:39:22 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a21so12949903ejj.10
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 09:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EIJB07nrCzGDZ+N+IiFLS0EIKaFm7QfmKVHjouwG+i4=;
        b=VieNSHFlQLOPETCmx5kzQHuonK34hg3Wk7qK/NcxC0R3QnUzmpk2k0PCxVL3hUVBnr
         xOEZ+hjLKTV8/hk/SwBhpHIoZkq91R+6soPemR5oBYa5kphRnvOwQG5cIe7NpqykC2x+
         N5oRLEQzMX9pX9pc5/aAypgN8bu5vyzYuFBxsJAf9ej+ZxU7d+kObYJTO/CxQm8nwD11
         bsEZJ3lNRn6jVoX6Uie1uG2wY3z+dQ57AEYpGF2duNJ7sWQeAabUOufnTk1tDzOHxb1c
         gh+wAaW4553e2Tu+WfhaR8aEIZLi3M0FKQU4FHGWv5EIBfmhCHo75MbXVvdj3fYk98Hf
         z1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EIJB07nrCzGDZ+N+IiFLS0EIKaFm7QfmKVHjouwG+i4=;
        b=mNGwgymYv7IHfoHwFHfwtbkcusalwQ+3y+LFAqNmmkyspBwM1S+wuttOauamqn3vPe
         ZugwpwzeAFVl5rxi+m5JFjtVgHTmwiPuYqOv8NcK00JNiFjNx4EU0IIUrZoW7liV2Zrp
         mVI8P1m18MQ3l1pQnDv2el0jGAu5tJpl6TV1MDI74MUKXc/fzNbIZBtXjW3zN8Unp+Tr
         Q3uLWVoO660N+qwm0sp1qyxOwTyq4ya+VQliTeksGvQCyJOjMq2lFZOGq50ZnTjnUxcN
         e/SOlCkuhOaR6e4iFE2YhETOIsAAFmucTYN7aCQLn0aUPhXZ6CM4kwMzeSa2KI/3ndft
         CpIw==
X-Gm-Message-State: AOAM531xFwRsMoeJahha3GxlRgXjSdfxxD0QqDEPIxYLjW3VKCe08qf1
        heWUW+L21NSEdrbbqnCdFu1qJwVUe/iaVXLWe5Zsdw==
X-Google-Smtp-Source: ABdhPJyxQx7z5yw7FESfQmVFfvYEpBAE1V0mv6N4umF9z8K2cGTz1b41/2urKTbWJ7BhnEnFxPe7bFTCMmqs3xubNNg=
X-Received: by 2002:a17:906:3bd5:: with SMTP id v21mr9903065ejf.329.1595695161456;
 Sat, 25 Jul 2020 09:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
 <20200713174320.3982049-2-anthony.l.nguyen@intel.com> <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
 <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
 <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8026dce002758d509b310afa330823be0c8191ec.camel@intel.com> <20200722180705.23196cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200722180705.23196cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 25 Jul 2020 09:39:07 -0700
Message-ID: <CALx6S36K0kES3b7dWmyigpSLgBmU2jf7FfCSYXBFOeBJkbQ+rw@mail.gmail.com>
Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "Wang, Haiyue" <haiyue.wang@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 6:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 23 Jul 2020 00:37:29 +0000 Venkataramanan, Anirudh wrote:
> > Can you please clarify how you (and the community) define bifurcated
> > driver?
>
> No amount of clarification from me will change the fact that you need
> this for DPDK.

Jakub,

The fundamental problem we have wrt DPDK is that they are not just
satisfied to just bypass the kernel datapath, they are endeavouring to
bypass the kernel control path as well with things like RTE flow API.
The purpose of this patch set, AFAICT, is to keep the kernel in the
control plane path so that we can maintain one consistent management
view of device resources. The unpleasant alternative is that DPDK will
send control messages directly to the device thereby bypassing the
kernel control plane and thus resulting in two independent entities
managing the same device and forcing a bifurcated control plane in the
device (which of course results in a complete mess!).

Tom
