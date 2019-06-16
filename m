Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7393A4760A
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 19:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfFPROo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 13:14:44 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41425 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfFPROo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 13:14:44 -0400
Received: by mail-io1-f67.google.com with SMTP id w25so16235330ioc.8;
        Sun, 16 Jun 2019 10:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X4WrkjaQQpTlNjMoovx5rY40SD+a9Kp8afFJnM+fxs8=;
        b=DtBTpHDxVxOt6zVeqDkWmoLKrJvKKvlWytU3DSb5/ZSiXl+/GarLsfhGOsI6Pcn5ra
         GnfkKgJx3VCEcKFn/yeXmTIdvisj1Id7d4a77IVLU3J8O08ruqLOX8wU20skBO2JkTLm
         Evwp1+BKfbLnXv2plxC4a/RfZZ8Rm4KvwfqJFCC7aM9JptlI62Emd//AWbsTsaa6hDd8
         5AJL4twEvTNC6MvcVg6lAP3LP88o1Wu3Y0znNnzYt5E7Ly2190Qz4TnuvLPZgZRPMCP1
         Kga65S72qqbFLX6jh/cnVjvFIIeYrsuEkfgsmdUm5qMnHM3VCBgcMKeo8cMwE3i5AwTA
         vNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X4WrkjaQQpTlNjMoovx5rY40SD+a9Kp8afFJnM+fxs8=;
        b=H+wTOCHZs04e4/F2q2Pm3BmFLdWZwJzig20GxNMjsQOnd+UbhB1cW+3iIA/IfiPnPh
         2ZmdPFOz4FxzgNisbwZ6AUTsglwbFgBlyh8JoFOSMVrq77pofAqXI2y1NocdNK81+/IQ
         jjWkHBOzFhRi6ui/gHZuv0lJtuKiq5eyScoDwbgoQ5smWTjyCo6hcBvGkfAJdrrHqsf/
         GRT7FGokM5WaI8IBi/fc6oIJ39l2HpePADMPrKoWZ2ZiKbQbW9JGPeqLnn2QsQx9asG+
         xadeDKZkjvxaEeDAYbwY5P4g1cGkHDxIwIkq+saBfP+MZaEz814SWjmtGHg8xXbgzfCb
         iZew==
X-Gm-Message-State: APjAAAU9s6FvdfI8Vn2qHERpbCvc+Eu33rBJi/DoiU1fNdSAk9kkVmvT
        RB9dsQI8vuuVobdGQa9EjxiYxX9VYIvfP8U54qs=
X-Google-Smtp-Source: APXvYqyxtZq0gEu9LqJooDjhP0+ruL974qi24V0L/KYODE0xHaWL2snu4Y8IU+laFHrkpbIPTIhYimHeI9K/beK7Gac=
X-Received: by 2002:a5e:8618:: with SMTP id z24mr72484671ioj.174.1560705283278;
 Sun, 16 Jun 2019 10:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20180429104412.22445-1-christian.brauner@ubuntu.com>
 <20180429104412.22445-3-christian.brauner@ubuntu.com> <CAKdAkRTtffEQfZLnSW9CwzX_oYzHdOE816OvciGadqV7RHaV1Q@mail.gmail.com>
 <875zp5rbpf.fsf@xmission.com> <20190616165027.prdbshnipwphqtis@gmail.com>
In-Reply-To: <20190616165027.prdbshnipwphqtis@gmail.com>
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Sun, 16 Jun 2019 10:14:32 -0700
Message-ID: <CAKdAkRT98DmxCHPL+1+COinSEDU0_87GMDL6ZiQEiBJSd286yw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2 v5] netns: restrict uevents
To:     Christian Brauner <christian.brauner@canonical.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, avagin@virtuozzo.com,
        ktkhai@virtuozzo.com, "Serge E. Hallyn" <serge@hallyn.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

On Sun, Jun 16, 2019 at 9:50 AM Christian Brauner
<christian.brauner@canonical.com> wrote:
>
> Hey Dmitry,
>
> Crostini on ChromeOS is making heavy use of this patchset and of LXD. So
> reverting this almost 1.5 years after the fact will regress all of
> Google's ChromeOS Crostini users, and all LXD/LXC users.
>
> LXD and Crostini by using LXD (through Concierge/Tremplin etc. [2]) are
> using this whole series e.g. when hotplugging usb devices into the
> container.
>
> When a usb hotplug happens, LXD will receive the relevant uevent and
> will forward it to the container. Any process listening on a uevent
> socket inside the container will now be able to see it.
>
> Now, to talk briefly about solutions:
> From what I gather from talking to the ChromeOS guys and from your
> ChromeOS bugtracker and recent patchsets to ARC you are moving your
> Android workloads into Crostini? So like Eric said this seems like a new
> feature you're implementing.

No, I am talking about ARC, not Crostini here.

>
> If you need to be able to listen to uevents inside of a user namespace
> and plan on using Crostini going forward then you can have Crostini
> forward battery uevents to the container. The logic for doing this can
> be found in the LXD codebase (cf. [3]). It's pretty simple. If you want
> to go this route I'm happy to guide you. :)
> Note, both options are a version of what Eric suggested in his last
> paragraph!
>
> What astonishes me is that healthd couldn't have possibly received
> battery uevents for a long time even if Android already was run in user
> namespaces prior to the new feature you're working on and the healthd I
> see in master is not even using uevents anymore (cf. [8]) but rather is
> using sysfs it seems. :)
> Before that healthd was using (cf. [7])
>
> uevent_kernel_multicast_recv()
> |
> -> uevent_kernel_multicast_uid_recv
>
> the latter containing the check
>
> if (cred->uid != 0) {
>     /* ignoring netlink message from non-root user */
>     goto out;
> }
>
> Before my patchset here the uevents sent out came with cred->uid == INVALID_UID
> and so healthd never received those events until very recently.

I see. OK, let me try digging into this to figure out what exactly changed.

Thanks.

-- 
Dmitry
