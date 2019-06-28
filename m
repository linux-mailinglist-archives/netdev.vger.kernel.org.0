Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876405A608
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfF1Usx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:48:53 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46719 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1Usx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:48:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id h21so7821991qtn.13
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 13:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=83l4te6CzoiJ/sWfVHXRDS4rm5S6C+0TS1rfwDYJ3qo=;
        b=k6okyzBiXT9qYQ3odougz14DsKrpYczp7W/aLI8dfxPmZ47GVVk+IcoLbFzeS4SoR1
         DulSRLJ1GltFgOCs0PsQFSLooPDCfLLyWOulwza8dA3L+YdUttaZIZCADJ48NTG02f/C
         uuvcNQAppqeESASpABwXKYbHq51onYI5f1/kSEp4kQn/3olh/8lykGvLg2ECzrqiXY2z
         NErP71whtd2mY3hB7jbW2U+B5gI5g2bW0Yv2SKrUNCNdrhallDNRN7p6bb6bHVqDUHnM
         WU7sTttq6qraejDT0eYj0R4KGuyMFuL/e1misqHg+BYtVMfHs1tsVde8XtPLU7EnrxGX
         V0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=83l4te6CzoiJ/sWfVHXRDS4rm5S6C+0TS1rfwDYJ3qo=;
        b=bwclJQUj4da9DAGxKsEHGcwr1ap0VchALZHOUQx0jygDD84vvWx6epxe41tFfLCisW
         omwpDTN+5+8lERHoK8T+onJNBw2XfyfRp3XgByxZM1YHwMHIlY5cGMojTWsK4vX3bAEM
         XSrZPn0raOKFWvAEjSdNrQsPCSCZvn08Axt3E0t32CDgIw5/Spvmltox1SpG2cyLnCwW
         IxEF8pffEyLOlWRTPnBON3N2JSOee59oYfhJbHfZs2QLxuExr6NfCjSXvFiNsUvgTJNd
         AjPAdVdk1CS1epHozlD+PVQzqQXKAj3DL2PTbDpaHnDWBa5mM8ixzGNhjbllqixi3o/y
         mcOA==
X-Gm-Message-State: APjAAAUKLXFIOUSTXpYu4+suvwGGqYsi1EuUSw3sfOOVfLEEdBX4TdCr
        +yKPwZmQMuXQasEXze6G9Iw/vQ==
X-Google-Smtp-Source: APXvYqwm/5tduHKr2kxpyyEpMqmzhyMPYQQlBktTLX40wrg2B7gFmULeSShoWGcDG4nBneVXrEnpkQ==
X-Received: by 2002:a0c:d4b3:: with SMTP id u48mr9870656qvh.246.1561754931869;
        Fri, 28 Jun 2019 13:48:51 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t29sm1686388qtt.42.2019.06.28.13.48.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 13:48:51 -0700 (PDT)
Date:   Fri, 28 Jun 2019 13:48:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, saeedm@mellanox.com,
        maximmi@mellanox.com, brouer@redhat.com, kernel-team@fb.com
Subject: Re: [PATCH 4/6 bfp-next] Simplify AF_XDP umem allocation path for
 Intel drivers.
Message-ID: <20190628134847.74bea2fb@cakuba.netronome.com>
In-Reply-To: <32DD3CE5-327F-4D76-861B-7256F3F10EC9@gmail.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
        <20190627220836.2572684-5-jonathan.lemon@gmail.com>
        <20190627154206.5d458e94@cakuba.netronome.com>
        <32DD3CE5-327F-4D76-861B-7256F3F10EC9@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 19:36:42 -0700, Jonathan Lemon wrote:
> On 27 Jun 2019, at 15:42, Jakub Kicinski wrote:
> > Could you be more explicit on the motivation?  I'd call this patch set
> > "make all drivers use reuse queue" rather than "clean up".  
> 
> The motivation is to have packets which were received on a zero-copy
> AF_XDP socket, and which returned a TX verdict from the bpf program,
> queued directly on the TX ring (if they're in the same napi context).
> 
> When these TX packets are completed, they are placed back onto the
> reuse queue, as there isn't really any other place to handle them.
> 
> It also addresses Maxim's concern about having buffers end up sitting
> on the rq after a ring resize.
> 
> I was going to send the TX change out as part of this patch, but
> figured it would be better split unto its own series.

Makes sense, please put that info in the cover letter.  (in other nit
picks please prefix the patches which the name of the subsystem they
are touching - net: xsk: ?, and make sure all changes have a commit
message).

Looking at this yesterday I think I've seen you didn't change the RQ
sizing -  for the TX side to work the rq size must be RX ring size
+ XDP TX ring size (IIRC that was the worst case number of packets
which we may need to park during reconfiguration).  

Maybe you did do that and I missed it.

> > Also when you're changing code please make sure you CC the author.  
> 
> Who did I miss?

commit f5bd91388e26557f64ca999e0006038c7a919308
Author: Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Fri Sep 7 10:18:46 2018 +0200

    net: xsk: add a simple buffer reuse queue

    XSK UMEM is strongly single producer single consumer so reuse of
    frames is challenging.  Add a simple "stash" of FILL packets to
    reuse for drivers to optionally make use of.  This is useful
    when driver has to free (ndo_stop) or resize a ring with an active
    AF_XDP ZC socket.
    
    Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
    Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>


Sorry to get upset, I missed a bpf patch recently and had to do 
a revert..
