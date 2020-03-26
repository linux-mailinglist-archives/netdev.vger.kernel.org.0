Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3701945E5
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 18:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgCZRzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 13:55:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54377 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCZRzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 13:55:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id c81so7494480wmd.4;
        Thu, 26 Mar 2020 10:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8l2oRnDlBMb0gXsLvGjz4aRGCAhqoB1hZgrGjPsa2To=;
        b=RhQmfK7zxsQz9efFQMf3Mgar0VVI4KEnYZVN24ZrLsHIMhWb+dRvc8+mZqQmF1LwqO
         DpYAPanXRGJSF+ymGAJZAyu+H1jY+mVs1Ste/CgMEux+jM8JmvEikda59HDUR8CVpYTy
         q2J9IQh2HJAGqgxWU1EVZ+CRu1rMtU3TiNFOdjeDfwuqMYY+JebAU3yd+x2APX8aeGwK
         Kn0jY19MNPeLE3h9aLAxZMYOHZMBwUMSOJq9q3lDooQtyaQ5VxqCFHwGwjFEn/IO7WRM
         qPJgDo5buaIoEj4MUshrYNO2xbk469eB83cRM35NUwBLbzT0t6iA6lx41Z7XBjuFdNGI
         Ymqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8l2oRnDlBMb0gXsLvGjz4aRGCAhqoB1hZgrGjPsa2To=;
        b=JEO64nfeATFcSLk2q5aIk/QGRyKqobSuF3J29u/H5vQ+OQjye2ra6jCIyoDDcNBFLJ
         JKtAjTMOJj2JfgCIuXlmeAdnhXq1aflptYACJ7x4LlDX4pkBb/GJKQssmFfaOZjsn6Fb
         3powiKcS7gb1SSF8ic0A4XJen+O4cENKFCQ/3W3EloLQ9CMHUBGSSpdtzllvOlQM+8Qr
         X7r/7PUuaQE+84xbM40XzX7Ywe0lZm1AD/x4hcB0bMqmHfih2rbasDVwwUQiSHo4L+RW
         Jbg+zp1i4qPtHLNXt0XRv9Vj0PdDvJXjRDZfOz8+d4d9OC17YHHveRdG2Wvc53u0+pd7
         857Q==
X-Gm-Message-State: ANhLgQ3kS6DJXvqIIzU9kPQWAckQDJYfqhrtoHvwAnM2CY1xD0+gfKnH
        I3449745MP1fnJL3xcOw9i4=
X-Google-Smtp-Source: ADFU+vvQYAns/H4naOtzD0AQEl0lguuS8ZgJ+3MxwcxBvnyytUVJtfuzo3jqR3eODXmd0fraia5JTA==
X-Received: by 2002:a7b:c1da:: with SMTP id a26mr1177478wmj.91.1585245342367;
        Thu, 26 Mar 2020 10:55:42 -0700 (PDT)
Received: from andrea ([86.61.236.197])
        by smtp.gmail.com with ESMTPSA id w9sm5014104wrk.18.2020.03.26.10.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 10:55:41 -0700 (PDT)
Date:   Thu, 26 Mar 2020 18:55:31 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 04/11] hv_netvsc: Disable NAPI before closing the
 VMBus channel
Message-ID: <20200326175531.GA20523@andrea>
References: <20200325225505.23998-1-parri.andrea@gmail.com>
 <20200325225505.23998-5-parri.andrea@gmail.com>
 <20200326082636.1d777921@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326082636.1d777921@hermes.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 08:26:36AM -0700, Stephen Hemminger wrote:
> On Wed, 25 Mar 2020 23:54:58 +0100
> "Andrea Parri (Microsoft)" <parri.andrea@gmail.com> wrote:
> 
> > vmbus_chan_sched() might call the netvsc driver callback function that
> > ends up scheduling NAPI work.  This "work" can access the channel ring
> > buffer, so we must ensure that any such work is completed and that the
> > ring buffer is no longer being accessed before freeing the ring buffer
> > data structure in the channel closure path.  To this end, disable NAPI
> > before calling vmbus_close() in netvsc_device_remove().
> > 
> > Suggested-by: Michael Kelley <mikelley@microsoft.com>
> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: <netdev@vger.kernel.org>
> 
> Do you have a test that reproduces this issue?

I don't (or I'm not aware of such a test).


> 
> The netvsc device is somewhat unique in that it needs NAPI
> enabled on the primary channel to interact with the host.
> Therefore it can't call napi_disable in the normal dev->stop() place.
> 
> Acked-by: Stephen Hemminger <stephen@networkplumber.org>

Thanks!

  Andrea
