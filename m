Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1CFA19F64D
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgDFNCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:02:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35654 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728118AbgDFNCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586178129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VPjD/qOa5eohxkp3ciJYq8E962y8rH1Z+TEQ1dfdaNU=;
        b=LIVgOdOL/H71WNHI6o90ZKZ+LyhODZU3q3afogGyvFjRXlAPPvL3ipCXzVo2FfjBG6GkAQ
        g9216cAy+xzFi+rIOBohXTlybg5OX3Nl73WkqmalatmzM9WhNoggwaClz7i7YOmnb9Upwh
        4aEol6VgOQiLIpykmU8hxnvHAzs5nl8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-WtBNpD-hPy6CpLxoSLf8EA-1; Mon, 06 Apr 2020 09:02:07 -0400
X-MC-Unique: WtBNpD-hPy6CpLxoSLf8EA-1
Received: by mail-wr1-f71.google.com with SMTP id j12so8278958wrr.18
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 06:02:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VPjD/qOa5eohxkp3ciJYq8E962y8rH1Z+TEQ1dfdaNU=;
        b=rlO7yWCkRf3FZjn8khtvaagylevp2PwxjTT9zHa1rhUlzESh0WqrpJPF0syUOnR4BK
         3QhRzLlX9lzpR5aBYELirsd8vKZpvy1Sa+TAVXZHfLMbxdNet203/ZX95reru1/g2EQe
         o6j9zOqj0rj+aKLLEIVSPOnkME1otGX4GPPq6ZyoLc/DBdhjmD0aqOPRB/MGx5E8IjFt
         GZzGdEVu2uIWXOkWvfwp1wUh71NR366/gtGDuTALUZbJnGoqWKu7Bd8Rt660hDq6qdDo
         WJxjGJNd+Mo43jOOGd83uxbmq9+khe8OL6zk5m9MtYNqUlm2MN7+M3efU+qTnDBp01+o
         9pGQ==
X-Gm-Message-State: AGi0Puba+k6dMgg3yQqf3u06dDe0ioWRg4fxK6/0YzJ42Xmqaa1d/sgT
        LVnlGMDlN14r82HXYaVOYHum0mKbmh+cSQ67hSqm5hBVwzAdP3YPdwKH6B4iVdG5y87NyOYgZcc
        8BMRYmCHlv35Dxhb/
X-Received: by 2002:adf:a350:: with SMTP id d16mr23217857wrb.277.1586178126528;
        Mon, 06 Apr 2020 06:02:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypKzhJTMgG+3y4mdFbTRg4CPv7sYAgX9HM+UKNa2TYFJhIuv1nrWp08PsZCLMr3COjkc520wRg==
X-Received: by 2002:adf:a350:: with SMTP id d16mr23217808wrb.277.1586178126236;
        Mon, 06 Apr 2020 06:02:06 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id n1sm13731659wrw.52.2020.04.06.06.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 06:02:05 -0700 (PDT)
Date:   Mon, 6 Apr 2020 09:02:02 -0400
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
Message-ID: <20200406085707-mutt-send-email-mst@kernel.org>
References: <20200406121233.109889-1-mst@redhat.com>
 <20200406121233.109889-3-mst@redhat.com>
 <CAK8P3a1nce31itwMKbmXoNZh-Y68m3GX_WwzNiaBuk280VFh-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1nce31itwMKbmXoNZh-Y68m3GX_WwzNiaBuk280VFh-Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 02:50:32PM +0200, Arnd Bergmann wrote:
> On Mon, Apr 6, 2020 at 2:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> 
> >
> > +config VHOST_DPN
> > +       bool "VHOST dependencies"
> > +       depends on !ARM || AEABI
> > +       default y
> > +       help
> > +         Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
> > +         This excludes the deprecated ARM ABI since that forces a 4 byte
> > +         alignment on all structs - incompatible with virtio spec requirements.
> > +
> 
> This should not be a user-visible option, so just make this 'def_bool
> !ARM || AEABI'
> 
>       Arnd

I like keeping some kind of hint around for when one tries to understand
why is a specific symbol visible.

-- 
MST

