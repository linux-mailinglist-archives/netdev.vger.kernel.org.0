Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9312221AF0E
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 07:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGJF6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 01:58:31 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53179 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725802AbgGJF6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 01:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594360708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C4LnrvqT9+DNx24YkEZw2+SXe1o6FKiLlzwpTypzG8A=;
        b=Y+XxOvBjEbl9F7XdtOTWEY97JVlA/4JP9m1OmOM/D/jNmDESGG8eUGLrkYTpi8iDjHO65f
        DcJzt/9EtJvnxVr49HXpyCfTyPviqACGraWwl9LAp+nvbzYOwfs3ZJ/2BEaJ1Ey//5I0mk
        Ry4yH4AO8/XNtQnB4TbTvmqSHnhav1M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-ZD-6VCJxNga62OFj6PP7Kg-1; Fri, 10 Jul 2020 01:58:26 -0400
X-MC-Unique: ZD-6VCJxNga62OFj6PP7Kg-1
Received: by mail-wm1-f70.google.com with SMTP id q20so5291623wme.3
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 22:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C4LnrvqT9+DNx24YkEZw2+SXe1o6FKiLlzwpTypzG8A=;
        b=IU4gcZw2Bz8yi76ZBgtKzCAv2CX6gA2K3TvA1Aean6YYLK1Fcu7h+fG8koxRX7dAt8
         gf6uVW7ZdOjdFbEd8oexj5FSf18LI0i/EKMeB5LC1OHDT0VS4LefrOQdidJmUm5t6bCK
         TXv0TRE38L4BEKGwiHnHqyRenr6/gV9aJ3Idg+uW5+PmSlK+Da5XTeg9cZpXVf1kuCxW
         WX+e/qzzeA02dvzDT2iKWicH7e5YKokQIF0AzPsQo0RgMBuUnpdJYI2olq5lIE6/hcwt
         4UrVWahfg8/rWeVpCYezqG4blvv9PS1iF48F9cKNwsklwvOA+D++B0q32rWlxCvQyRw9
         jc1A==
X-Gm-Message-State: AOAM533QomKyHfqJxqpU3Wcj3rlRzaSK9OwrkYbRDfe+eX6/6Eff3m/l
        xTrWqwK2Etm3xgsUhnDZujeOKkvgEP8rhZpt2Ye3vfaIhK1YfFDV4cazWynSvBXrKgFYmJRzq0+
        0J+gWI1qtVUfdp23p
X-Received: by 2002:a7b:c38f:: with SMTP id s15mr3394782wmj.152.1594360705672;
        Thu, 09 Jul 2020 22:58:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLn6mDVLNvrd8u4soiaqjHIlkFvr4sTxn75hYjrWzq/00SA7DFxiythkthHZ5njp79o9gOug==
X-Received: by 2002:a7b:c38f:: with SMTP id s15mr3394766wmj.152.1594360705488;
        Thu, 09 Jul 2020 22:58:25 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id j15sm8366155wrx.69.2020.07.09.22.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 22:58:24 -0700 (PDT)
Date:   Fri, 10 Jul 2020 01:58:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
Message-ID: <20200710015615-mutt-send-email-mst@kernel.org>
References: <20200622122546-mutt-send-email-mst@kernel.org>
 <CAJaqyWfbouY4kEXkc6sYsbdCAEk0UNsS5xjqEdHTD7bcTn40Ow@mail.gmail.com>
 <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com>
 <419cc689-adae-7ba4-fe22-577b3986688c@redhat.com>
 <CAJaqyWedEg9TBkH1MxGP1AecYHD-e-=ugJ6XUN+CWb=rQGf49g@mail.gmail.com>
 <0a83aa03-8e3c-1271-82f5-4c07931edea3@redhat.com>
 <CAJaqyWeqF-KjFnXDWXJ2M3Hw3eQeCEE2-7p1KMLmMetMTm22DQ@mail.gmail.com>
 <20200709133438-mutt-send-email-mst@kernel.org>
 <7dec8cc2-152c-83f4-aa45-8ef9c6aca56d@redhat.com>
 <CAJaqyWdLOH2EceTUduKYXCQUUNo1XQ1tLgjYHTBGhtdhBPHn_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJaqyWdLOH2EceTUduKYXCQUUNo1XQ1tLgjYHTBGhtdhBPHn_Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 07:39:26AM +0200, Eugenio Perez Martin wrote:
> > > How about playing with the batch size? Make it a mod parameter instead
> > > of the hard coded 64, and measure for all values 1 to 64 ...
> >
> >
> > Right, according to the test result, 64 seems to be too aggressive in
> > the case of TX.
> >
> 
> Got it, thanks both!

In particular I wonder whether with batch size 1
we get same performance as without batching
(would indicate 64 is too aggressive)
or not (would indicate one of the code changes
affects performance in an unexpected way).

-- 
MST

