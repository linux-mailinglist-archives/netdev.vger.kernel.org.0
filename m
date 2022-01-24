Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337A1499BFF
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiAXV6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:58:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1453608AbiAXVad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:30:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643059829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BPviI4NYa0mRWVJtF8dh+5Zul5wro2/2PTxymOy6bSI=;
        b=FEvxyQakd4PHvNCpe1vuTaOKgfIsmEU79tG0aQHifHjf+PD0SbxPJySqba2OlaW6jCKyJm
        90J6OEeunk7mz3zyEA/DfLqKLbDUTDXHctvJzbzJA6lbeEnLooEa4fnLfa4kMaGlpVJPdZ
        /Ayt24kOcc3cPCC68Fubg+kJxaePvQ0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-aDOFPuydP36V11cFIpGJSw-1; Mon, 24 Jan 2022 16:30:28 -0500
X-MC-Unique: aDOFPuydP36V11cFIpGJSw-1
Received: by mail-qk1-f200.google.com with SMTP id h10-20020a05620a284a00b0047649c94bc7so13245176qkp.20
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 13:30:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BPviI4NYa0mRWVJtF8dh+5Zul5wro2/2PTxymOy6bSI=;
        b=w737juCH1iBeEBaw6TMmwGdOVek1G2lETyyvYXZgf/sFe1rUrQliKOgso6Yt7dwAMx
         PnaHQEuUiEukBplUwHDevHHuat7GKAaw9TbcjJrkR3yO3zyOGAWBYs9Qz3QeFDXBF6kn
         8YBRD+uAnJ5HD0XIoeZJaR0SfaSmHowPHGNSrQqIVAsZVCtjlcLE3nVl3djx/dZAxc1w
         F26LN8tZJSlDUO9yzALv1a9msa4N3kP9YAO0zdipCZZSup25bByHQOCgwuPIcQSYz0oi
         cI5UriKTeXCTe3YniXKyIxDwxoBbQ2n6fcYrbmNxJcvnhmUjIj5hf8hZ+6NMX1/emL8Y
         s/Pg==
X-Gm-Message-State: AOAM533d5AOhvAsgtVcLJ186rqoJTQPomL7Laj8gl5F/T5GtuJEra9fU
        W8Q0fJrpQy+PtxW4faRQVk4Kn+xYeNb8BWQWJlGJ/r92qddb1ir7GtMBHrvUPbZjQlbE5NMcGNG
        qvv69vVllgj3dv/og
X-Received: by 2002:a05:622a:4d3:: with SMTP id q19mr14128093qtx.425.1643059827538;
        Mon, 24 Jan 2022 13:30:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxOB0lOhE0/2e3RUDYNlVvMoUfvFj6XzNPE37YtZtmuY7SEw6Zy9iiU9v6XhBf//u5g2arcFQ==
X-Received: by 2002:a05:622a:4d3:: with SMTP id q19mr14128070qtx.425.1643059827257;
        Mon, 24 Jan 2022 13:30:27 -0800 (PST)
Received: from localhost (net-37-119-146-61.cust.vodafonedsl.it. [37.119.146.61])
        by smtp.gmail.com with ESMTPSA id m22sm7700698qtk.37.2022.01.24.13.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 13:30:26 -0800 (PST)
Date:   Mon, 24 Jan 2022 22:30:21 +0100
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Wen Liang <wenliang@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Message-ID: <Ye8abWbX5TZngvIS@tc2>
References: <cover.1641493556.git.liangwen12year@gmail.com>
 <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
 <20220106143013.63e5a910@hermes.local>
 <Ye7vAmKjAQVEDhyQ@tc2>
 <20220124105016.66e3558c@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124105016.66e3558c@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 10:50:16AM -0800, Stephen Hemminger wrote:
> On Mon, 24 Jan 2022 19:25:06 +0100
> Andrea Claudi <aclaudi@redhat.com> wrote:
> 
> > On Thu, Jan 06, 2022 at 02:30:13PM -0800, Stephen Hemminger wrote:
> > > On Thu,  6 Jan 2022 13:45:51 -0500
> > > Wen Liang <liangwen12year@gmail.com> wrote:
> > >   
> > > >  	} else if (sel && sel->flags & TC_U32_TERMINAL) {
> > > > -		fprintf(f, "terminal flowid ??? ");
> > > > +		print_bool(PRINT_ANY, "terminal_flowid", "terminal flowid ??? ", true);  
> > > 
> > > This looks like another error (ie to stderr) like the earlier case
> > >  
> > 
> > Hi Stephen,
> > Sorry for coming to this so late, but this doesn't look like an error to me.
> > 
> > As far as I can see, TC_U32_TERMINAL is set in this file together with
> > CLASSID or when "action" or "policy" are used. The latter case should be
> > the one that this else branch should catch.
> > 
> > Now, "terminal flowid ???" looks to me like a message printed when we
> > don't actually have a flowid to show, and indeed that is specified when
> > this flag is set (see the comment at line 1169). As such this is
> > probably more a useless log message, than an error one.
> > 
> > If this is the case, we can probably maintain this message on the
> > PRINT_FP output (only to not break script parsing this bit of info out
> > there), and disregard this bit of info on the JSON output.
> > 
> > What do you think?
> > 
> > Regards,
> > Andrea
> > 
> 
> Just always put the same original message on stderr.
> 

Let me phrase my case better: I think the "terminal flowid" message
should not be on stderr, as I don't think this is an error message.

Indeed, "terminal flowid ???" is printed every time we use "action" or
"policy" (see my previous email for details), even when no error is
present and cls_u32 is working ok. In these cases, not having a flowid
is legitimate and not an error.

As this is the case, I think the proper course of action is to have this
message printed out only in non-json output to preserve the same output
of older iproute versions. It would be even better if we decide to
remove this message altogether, as it is not adding any valuable info to
the user.

