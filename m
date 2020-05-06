Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DCC1C6FBE
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgEFL5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:57:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60178 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726924AbgEFL5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588766267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8SQDFnlIJbT5ua1JOyFwQCxTImV9nf4dY7BK+J1cBSE=;
        b=fVO5Ddl3bulPKi/gByVHCqOr/l1SwSAzqUlEHpfGrhQt23K29RCOY34MJi8OhOVNwhBIBd
        c4JjscmggfhcN8/OuTQ3fz4JSRJ9PUGXOVXLCdYHvkJA3CZWcm63fc01+BQnyfOKPbzfZr
        e9XnRRqA8t1+zri58pyTGAKlXlGOEm4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-U8D4NsYRMluEvww3yfdbCw-1; Wed, 06 May 2020 07:57:45 -0400
X-MC-Unique: U8D4NsYRMluEvww3yfdbCw-1
Received: by mail-wm1-f69.google.com with SMTP id j5so1095298wmi.4
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 04:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8SQDFnlIJbT5ua1JOyFwQCxTImV9nf4dY7BK+J1cBSE=;
        b=dz9V4sajLiddedwCKfh+Aek9P5+kP6zJ4XHcgyL+UGJ2WX0YKs34HCV+fVqHIrpyDK
         85AuKDmb3lvPDA901znzqKP+9y+wGpY6bmnrwz6BzYr3YlIW1S6FPKt56YpWT3eZCXLs
         0Usvt78DTQm0Xcd1dtbEa0/v3v/BjpWLMVmd7BU86w2pPp51DVEJ8Wx2GhMQ5DPgA3Je
         6tgqH3thvDIShB52H303sq7IZGhLHnw8WdAbGselYdSQ4TC5WZDTv7ZbhsYYwEyHtRS5
         cUQMlRn05KYXfevLBwjVhHecrN+DJIjP54Vydpwsh1K6wA/Jk2U8i4xUXY2ScmuMcVd5
         kY7Q==
X-Gm-Message-State: AGi0PuacBALgiKG0E/42b9nlFE/zg4WyCphJNaFs2joQ4ULuh0ExWdNs
        6hDvSgRAc367IAN64TjaAoM+MRBXs/PdYyuDpBhGl3AhECNBLqMCRqPsfCRdGTdz6QWCGexglm0
        LsXl15nDZ8jYlGF5T
X-Received: by 2002:a05:600c:2210:: with SMTP id z16mr4188079wml.151.1588766264429;
        Wed, 06 May 2020 04:57:44 -0700 (PDT)
X-Google-Smtp-Source: APiQypKgPL6Idtx8YS8ZSPniHEZVsgz6k4KI77A+1MaVArInKjm4b6YSX9fRi88QPhdunVwvyGecRg==
X-Received: by 2002:a05:600c:2210:: with SMTP id z16mr4188044wml.151.1588766264058;
        Wed, 06 May 2020 04:57:44 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id a139sm1060804wme.18.2020.05.06.04.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 04:57:43 -0700 (PDT)
Date:   Wed, 6 May 2020 07:57:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>
Subject: Re: performance bug in virtio net xdp
Message-ID: <20200506075719-mutt-send-email-mst@kernel.org>
References: <20200506035704-mutt-send-email-mst@kernel.org>
 <7d801479-5572-0031-b306-a735ca4ce0e4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d801479-5572-0031-b306-a735ca4ce0e4@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 04:37:41PM +0800, Jason Wang wrote:
> 
> On 2020/5/6 下午4:08, Michael S. Tsirkin wrote:
> > So for mergeable bufs, we use ewma machinery to guess the correct buffer
> > size. If we don't guess correctly, XDP has to do aggressive copies.
> > 
> > Problem is, xdp paths do not update the ewma at all, except
> > sometimes with XDP_PASS. So whatever we happen to have
> > before we attach XDP, will mostly stay around.
> 
> 
> It looks ok to me since we always use PAGE_SIZE when XDP is enabled in
> get_mergeable_buf_len()?
> 
> Thanks
> 

Oh right. Good point! Answered in another thread.

> > 
> > The fix is probably to update ewma unconditionally.
> > 

