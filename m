Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C02E899
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 19:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbfD2RQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 13:16:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33082 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728767AbfD2RQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 13:16:40 -0400
Received: by mail-pl1-f194.google.com with SMTP id y3so4537179plp.0
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 10:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N1rTxSLfgkYf4Bq3WydL0UGSkgFMNzeDonoEidoFh38=;
        b=w7qFAPdCoF8iykgl2JaHZbcSWg7taZIQdunOsUhZSmcd1YYe3Py5cx/hmFDL0yjyPz
         ZddS5vlGK+YCwvJlpAqyCjrhcWBPwmlkIZiOgbSiQ2EbItYmrlIBX1cfpA5+w/X5W1+P
         IdE7U9Y/nvbX4taW25LvThq8s4U1svEhnMVXq0d7JoOyjFA19fui1TLmKl97xqeQk0tL
         ejz09WkQv9fZ12O7/IbmfM0RaSLrdbp9vZ4WAXwn9LKgGzpXM4vZQeyNFA7sVbTfxjMa
         QpEuwyQXI6ObAmPbdU0gxTII4YkKywdbUQNNaPhX0Y6Jrun1Kyhy7dz7fvl89Yu3AvlN
         XQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N1rTxSLfgkYf4Bq3WydL0UGSkgFMNzeDonoEidoFh38=;
        b=eynObqYenvTD08rqQ1fHgjCc0NPZrcteDS3h7rVqqLxMY+X1FEiNvg2fTJtp0CYIzT
         gX9su154rwIPT8Hh+92xyKZNJt73tncoCrWK6jelZgTPXH8bcNN+PTW11eAwljleWlsQ
         Xf9eqPEuJaGs9v2G8aAIyyjToYTQs7Q4oAlUjMrotSbVD9ln4qz5uDP+hIEoWG2rBP9E
         91bbXhsFMhrk2adz1SyM1r55/FxCZaEIgh17Qtk2+B1G2EWS5RiVCQgx75DooIUb8BDk
         qWogrLNuF0ywnYUW5gKpK4i6XHoKtyefH2idpDGwziILALf3jx5YwUyYSGvtV9YOFUiG
         /nGA==
X-Gm-Message-State: APjAAAX/Tfji6cr+rNA6Zg+iiAysRavnTxKwd8I2xW2vcx/MSt+dJQdP
        bmyfiCIeBLvHQjLT1WlQgAjktg==
X-Google-Smtp-Source: APXvYqzCXqlI+zYyxRxBDHG7f8Z52TDZxV1lilhn0AWAYGMLcCSCZvKzlMKadOcJd+JAkpmfTddWkg==
X-Received: by 2002:a17:902:ba8c:: with SMTP id k12mr44705519pls.213.1556558200079;
        Mon, 29 Apr 2019 10:16:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y23sm48553315pfn.25.2019.04.29.10.16.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 10:16:39 -0700 (PDT)
Date:   Mon, 29 Apr 2019 10:16:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] tc: add support for plug qdisc
Message-ID: <20190429101638.1a250c01@hermes.lan>
In-Reply-To: <b6629ad2cb9afe49615360d359fce60ef2b19915.camel@redhat.com>
References: <05c43d9415d196730ad382574a992497fd1d456d.1556121941.git.pabeni@redhat.com>
        <20190424134906.14311678@hermes.lan>
        <b6629ad2cb9afe49615360d359fce60ef2b19915.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Apr 2019 10:47:52 +0200
Paolo Abeni <pabeni@redhat.com> wrote:

> Hi,
> 
> On Wed, 2019-04-24 at 13:49 -0700, Stephen Hemminger wrote:
> > On Wed, 24 Apr 2019 18:29:39 +0200
> > Paolo Abeni <pabeni@redhat.com> wrote:
> >   
> > > +static int plug_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
> > > +{
> > > +	/* dummy implementation as sch_plug does not implement a dump op */
> > > +	return 0;
> > > +}
> > > +  
> > 
> > All qdisc must dump their state in same form as the parse option.  
> 
> Thank you for the feedback. 
> 
> The problem here is that the sch_plug qdisc does not implement the
> dump() qdisc_op, so this callback has nothing to dump.
> 
> Must I patch sch_plug first?
> 
> Thanks,
> 
> Paolo
> 

OK, lets put the patch in as is for now. And then fix the kernel, then add print?
