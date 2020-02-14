Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244E915D5EA
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbgBNKkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:40:20 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42648 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387397AbgBNKkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 05:40:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581676819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vWYOvtGFRfJ0BZfFsKJ/E3VS2gGyFnJz740zg3QPfW8=;
        b=YD4IA0RjnW+p4nSpOVGgu8ORh6D/QbUNFqMpfi6VxfpDyscwzfXH4zJ9XstbxkUPd5oIry
        V6CaC9QZEDM1ISHl8c9jw+DTIje2nr0HjQ34FL+GMyDwL8er44bF3EgiRPO2xwIKgMRtmN
        XsFNYzlly3vVhX0XgqIKQfmTqXaaMzA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-oGYgDphkO9-94BF4RQKjuA-1; Fri, 14 Feb 2020 05:40:13 -0500
X-MC-Unique: oGYgDphkO9-94BF4RQKjuA-1
Received: by mail-wr1-f70.google.com with SMTP id d15so3812725wru.1
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:40:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vWYOvtGFRfJ0BZfFsKJ/E3VS2gGyFnJz740zg3QPfW8=;
        b=g216U7qz6VfMBZZ85RK72DF/RJ1tbJuYSzAD3EkPTOKbdNgFEudDBrgJ04tVk7QuPQ
         roQsTUQ19W/Pgy8uNReewpA7fGmzh4IiWV8vUnEjM97ZA80zWFIas5Sjwhz/zBozvLtN
         G6xyqN969k4kMQY/3On0Gwx07EwLTKKimhN+K78yeE0q7rOVHRsq9NIPZv5/+PFtJQz9
         v4ppGi31TCK41NRrIqXvuuRcfu+s8oWakD77zBt1WTwaEsdmhdijd+ypaEnqXrM/BnDC
         T3Rm78TMnOZjdR4+Y69ealV8ekhGvS59MyqSpO7OAGc6bdXuSpLQAlFzlV3UjNY6ko83
         CnHg==
X-Gm-Message-State: APjAAAVBRws37SXTEuJRGwiWUaShLzJ0du6Vb4PV15xuJtlh1YLVMOUW
        GI7wNBNDYvLfJUGUq/lyIz9qMPaxQcYrdssK1hSsNVFGehP6NrI36dLznDtujmCCQjZvrKUC+PN
        kyfUwK9oQC+wr30Vg
X-Received: by 2002:adf:ed04:: with SMTP id a4mr3366346wro.76.1581676812642;
        Fri, 14 Feb 2020 02:40:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqxNh7IqdseRXf2THuvtLph14Cingy+quzWidup7sDYUQj32BFZFffkPz40zaoJJ58ezLzDcAg==
X-Received: by 2002:adf:ed04:: with SMTP id a4mr3366324wro.76.1581676812392;
        Fri, 14 Feb 2020 02:40:12 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id l132sm7006245wmf.16.2020.02.14.02.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 02:40:11 -0800 (PST)
Date:   Fri, 14 Feb 2020 11:40:09 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc:     "stefanha@redhat.com" <stefanha@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net v2] net: virtio_vsock: Enhance connection semantics
Message-ID: <20200214104009.id33ew3uznvmitsb@steredhat>
References: <38828afab4efd8f6b8b8c43501a5f164a2841990.camel@intel.com>
 <20200214091704.f6cvbj7a5cwx725b@steredhat>
 <28f00ab8065e1abedbfd4e198b0ed0bb8ba93ef4.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28f00ab8065e1abedbfd4e198b0ed0bb8ba93ef4.camel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 10:23:44AM +0000, Boeuf, Sebastien wrote:
> On Fri, 2020-02-14 at 10:17 +0100, Stefano Garzarella wrote:
> > Hi Sebastien,
> > the patch and the test look good to me!
> > I tested with virtio and VMCI transports and your test works great,
> > thanks!
> 
> I'm glad everything worked out well so quickly :)

:)

> 
> > 
> > I suggest split the patch in two, one for the fix and one for the
> > test.
> 
> Ok will do!
> 
> > 
> > Are you using git format-patch / git send-email?
> > I fought a little bit to apply it because of CRLF ;-)
> 
> Well I have been using evolution mail client, but I'm gonna use the
> proper way with git send-email.

A very useful tool is the Stefan's git-publish:
https://github.com/stefanha/git-publish

> 
> One question though, if I split this into 2 patches, I need to write a
> cover letter?

Yes, it is better.

Just a brief description of the series and its patches.

Thanks,
Stefano

