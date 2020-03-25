Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237C01922EE
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCYIiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 04:38:10 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39011 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgCYIiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:38:09 -0400
Received: by mail-lj1-f194.google.com with SMTP id i20so1515419ljn.6;
        Wed, 25 Mar 2020 01:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=u1JHVU3RAXWpWzxoEBTeSB/vNLewo28StJEFtqtyLoU=;
        b=atWEsClArOzGKdLN4osuAk7d+XSEIi82gzITfDKHYSAZ1c+WEd3Ip/J9eETstflnDX
         LqQd2q6Qz/8hg3HTYMLWyI1r/uM72eIqZfUXxCdkYr7yZws3ErK2kSKYsVGHg9Cm/mtf
         X32RT6WFx/DxNfiiCaK5OWiM6W7e7JeJWoOEDUpgi05XVpNAtJvKJtyzJhblBES6Z/65
         eVjEoRNppJWoaSaLMrUSnZYRRo6sbYBlTHOOD7K3R3s4Elu3PeBJ5C7L2ulwEL9qqsKz
         nUa//b6Qd9KEX8nStmeRXzWQurXqzw+nAWyASHspx5uRQOtfM4KAnUAZ5r+BnFZwaD/D
         axHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=u1JHVU3RAXWpWzxoEBTeSB/vNLewo28StJEFtqtyLoU=;
        b=UlVntKbe2jveYAAErnG5iWKhUbUaX0C/TvBgjuMlKDyQEPPkxpGN3GdsTnB65720L1
         d5rR+NchMvMqgSFrYiYuF9jiQpLhsSVwX4bFIajSRfZ5u6X2TOV15nzk4FCaciwb7uAM
         pzaut6vDU9Ax7BZriZz4OQG5mevW2jMd84s+Wm9GKJgoOb9T6imGzftlVxgsGYVuYzG8
         F1GcK3sh/LeiAcc8oSMl5dpDJGWbiImiz1q3Tv6u1ub8esq+Pftx3IKJXybeS0Wo8vak
         +tFExSslAm6150TWtYDFuhhm7HKdypD0qICRbTivdoLXHJYqQGGmmeHcF/i33cKk0Frw
         9zKg==
X-Gm-Message-State: ANhLgQ2IJyFH9Zyb4SesupW4iuvopgcCAPdAQ2bgb5qvMDxBeX/FEbtC
        xD49I2AmH/9G/tEGg0NQmYs=
X-Google-Smtp-Source: APiQypL8bMjMZDQevXNQgwWPs9QVjiJXOb2ocQYyMJ5E3G+qtV0tyxn/wNi26nCLubp8d+GA3TyEPA==
X-Received: by 2002:a2e:9797:: with SMTP id y23mr1235851lji.183.1585125484852;
        Wed, 25 Mar 2020 01:38:04 -0700 (PDT)
Received: from saruman (91-155-214-58.elisa-laajakaista.fi. [91.155.214.58])
        by smtp.gmail.com with ESMTPSA id f7sm522142ljj.4.2020.03.25.01.38.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Mar 2020 01:38:03 -0700 (PDT)
From:   Felipe Balbi <balbi@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        linux-pci@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Guo Ren <guoren@kernel.org>, linux-csky@vger.kernel.org,
        Brian Cain <bcain@codeaurora.org>,
        linux-hexagon@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Geoff Levand <geoff@infradead.org>,
        linuxppc-dev@lists.ozlabs.org,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [patch V3 03/20] usb: gadget: Use completion interface instead of open coding it
In-Reply-To: <20200321113241.043380271@linutronix.de>
References: <20200321112544.878032781@linutronix.de> <20200321113241.043380271@linutronix.de>
Date:   Wed, 25 Mar 2020 10:37:57 +0200
Message-ID: <87blokde3e.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Thomas Gleixner <tglx@linutronix.de> writes:

> From: Thomas Gleixner <tglx@linutronix.de>
>
> ep_io() uses a completion on stack and open codes the waiting with:
>
>   wait_event_interruptible (done.wait, done.done);
> and
>   wait_event (done.wait, done.done);
>
> This waits in non-exclusive mode for complete(), but there is no reason to
> do so because the completion can only be waited for by the task itself and
> complete() wakes exactly one exlusive waiter.
>
> Replace the open coded implementation with the corresponding
> wait_for_completion*() functions.
>
> No functional change.
>
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: linux-usb@vger.kernel.org

Do you want to carry it via your tree? If so:

Acked-by: Felipe Balbi <balbi@kernel.org>

Otherwise, let me know and I'll pick this patch.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl57GGUACgkQzL64meEa
mQY/phAAyKS/jK6b1hVevAPsOBS5Zyk+RBQmkmps/3C2lTyyturSmqT3TAMZyTZo
/HPtsvyUYn8RBI5Pa62mvcnGi+/Lmk76YzmUqn/VJRe+J8kjuFI6IoyT4uDxdUsB
qGTiuQ5qbV7Ft3fvLoEEbuyPZeDc/pbfFyK78ajdAYec4MGS8r12tWzhRZTRyRAG
4fb/PjPcfk8/9eTkdgnjgINZTiwT9YN7HWpEfajl3MhlYK9pZh/J7swRaYwZULBo
+eVd6a6ZYt0YLC8wVQ/kJ9Q3EttmWBwPJB4FIXMzYDkXx2Z898ZUKeIJ8IXlwKSh
CynbYGL7rNJQ+UDpVA8/y5Mqqnu3pAht/csgfrBxm/ukjkMphIDjpzuUaODgH5W3
Eb4EXNgvgspzEMgz6pv9INgPPh2tWRmBQex8qOLrs1xups+ZmhFSHGKCUs8hxlDj
Zk0U6Mce6mopXiCf2iVgrv9ItHlp4myA/HwWEub+LwOJi8tCt+vCjzXloWMx4Ha+
TNyxLHrqLaeTQoYgl1wJQMjIhmcrb9UMBaJ5FhKdaXAGfAeicPSzVqVHG/yl6nds
Z2cTMhW5kIxJDMAOuemeYZLY8PMzXrG5xHT7Da3yOzurIOmp2rhvhjpt9TpjKDLE
3qsBCaxpICoolHqV8bAov175RPtyVvv5zdyXWulMD/1c2kVYiiY=
=IAgh
-----END PGP SIGNATURE-----
--=-=-=--
