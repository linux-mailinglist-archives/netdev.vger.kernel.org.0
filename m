Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA3A19F6C6
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgDFNVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:21:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25407 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728296AbgDFNVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:21:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586179277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dt00ToAjgq6odVjJUr2HynAfwKXr6ghEKV21ZUG8JdU=;
        b=D0wZzzdU8PqTR3WbL5BZnu4mgcm6k3MgzZczh6Mct2UWT/MniQVMC6xvVBPeH02lFUp0Fk
        N2PjCGUO4iIECw24eVoCeC+FGJWUErKlmwb0/NIMHaoEcc8HYeNpTg1WWrt0gz66eLaxXO
        l2vkcxnW5uBDjeVLedMAp+0/9HbOepE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-QLYOVWgWMe2pOglbJhNHwA-1; Mon, 06 Apr 2020 09:21:15 -0400
X-MC-Unique: QLYOVWgWMe2pOglbJhNHwA-1
Received: by mail-wr1-f72.google.com with SMTP id 91so7498191wro.1
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 06:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dt00ToAjgq6odVjJUr2HynAfwKXr6ghEKV21ZUG8JdU=;
        b=DvBV5bg0VWPGeK0oDD90ugy36m3crOHHiiG9BeOXIIqKuMEIUNhRpGK/CrqeawWhkr
         4hkaPqELjNZ2RUfbZYV8Wthw7tYzHqvqAIhZEYATwyjrHYB9+WN00AR2uFUWtCh01S6o
         6+ApvLmPaX1GFkD1XfXg3B251PmH65Jgw3cca6JE22UJE6AmBInVcJbFsb47z5PdqGsb
         SBsQNpHUvYwYFGolHATahJeisYT2qQCRXHy5dNprhTcvYZfJQlMVkOfQAe9xMEvyFerK
         UAzTmeuWeOx+bsJcHyl59ZOjLVCUBy+HiQVin49tAsyrFWvwS6Fn0Qn3hLfczvlhb6xP
         nuXA==
X-Gm-Message-State: AGi0PuauvDo8neDu5BCq+2B/dbT7zOYfHnS5IvYPpV9gD6RdJliR1p3U
        Sxx5GeECnfkb1ESQZS1tqXDaIu1ZI+FhkeT4bGMCwm2lRD07q5YYmHSnN5lLllETgleDx5jOj6O
        4LzUohArhIkIWXo0/
X-Received: by 2002:a5d:42c1:: with SMTP id t1mr11428316wrr.215.1586179274431;
        Mon, 06 Apr 2020 06:21:14 -0700 (PDT)
X-Google-Smtp-Source: APiQypLTm0wN4Ob+KU8r6bjP+vUj5Sc5r+ElDJG7FGW/nVL32K8rRyDddIp810vWUMYetH05ffupWw==
X-Received: by 2002:a5d:42c1:: with SMTP id t1mr11428298wrr.215.1586179274273;
        Mon, 06 Apr 2020 06:21:14 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id z11sm11162174wrv.58.2020.04.06.06.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 06:21:13 -0700 (PDT)
Date:   Mon, 6 Apr 2020 09:21:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "christophe.lyon@st.com" <christophe.lyon@st.com>,
        kbuild test robot <lkp@intel.com>,
        "daniel.santos@pobox.com" <daniel.santos@pobox.com>,
        Jason Wang <jasowang@redhat.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] vhost: disable for OABI
Message-ID: <20200406092056-mutt-send-email-mst@kernel.org>
References: <20200406121233.109889-1-mst@redhat.com>
 <20200406121233.109889-3-mst@redhat.com>
 <CAK8P3a1nce31itwMKbmXoNZh-Y68m3GX_WwzNiaBuk280VFh-Q@mail.gmail.com>
 <20200406085707-mutt-send-email-mst@kernel.org>
 <CAK8P3a1=-rhiMyAh6=6EwhxSmNnYaXR9NWhh+ZGh4Hh=U_gEuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1=-rhiMyAh6=6EwhxSmNnYaXR9NWhh+ZGh4Hh=U_gEuA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 03:15:20PM +0200, Arnd Bergmann wrote:
> On Mon, Apr 6, 2020 at 3:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Apr 06, 2020 at 02:50:32PM +0200, Arnd Bergmann wrote:
> > > On Mon, Apr 6, 2020 at 2:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > >
> > > > +config VHOST_DPN
> > > > +       bool "VHOST dependencies"
> > > > +       depends on !ARM || AEABI
> > > > +       default y
> > > > +       help
> > > > +         Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
> > > > +         This excludes the deprecated ARM ABI since that forces a 4 byte
> > > > +         alignment on all structs - incompatible with virtio spec requirements.
> > > > +
> > >
> > > This should not be a user-visible option, so just make this 'def_bool
> > > !ARM || AEABI'
> > >
> >
> > I like keeping some kind of hint around for when one tries to understand
> > why is a specific symbol visible.
> 
> I meant you should remove the "VHOST dependencies" prompt, not the
> help text, which is certainly useful here. You can also use the three lines
> 
>      bool
>      depends on !ARM || AEABI
>      default y
> 
> in front of the help text, but those are equivalent to the one-line version
> I suggested.
> 
>      Arnd

Oh right. Good point. Thanks!

-- 
MST

