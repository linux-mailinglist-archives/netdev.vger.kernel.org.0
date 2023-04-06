Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162B36D9C52
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbjDFP3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbjDFP3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:29:20 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582781BCD;
        Thu,  6 Apr 2023 08:29:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so43206213pjp.1;
        Thu, 06 Apr 2023 08:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680794942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=619nQ0lsEgEINdCEqk6IT2CyO/5/oumKn1+zUtFno4k=;
        b=YnP4GgynlL7t7+IONZVDilf5FdPhppgHVhPH7qFsWwOeDXZPJ2gMBDgEa+TSEZ4gwJ
         VWgtTUa10TteY5POfC+h22Cb7gC+x6aGBpGPxo+8MTx5r+PYZc5ZNynUn4s3nZK4Is2b
         5q3K52/jo9yTZxmj50Qzdb4cU/KUjYQLjyT34WedNl2n7iTbqOhLvkITZMWvIlvXdCu0
         pR+CUptJ23IMUPtc0sDT/8y1TycaLyruUkEqOB0SMkNrRYUD2iaIGLzYM0o49eUs8sMD
         UpJus3VnJ2AR1GbAhWT3EmCmJIBTwQ2EKpdy+Zx5IpOuTMKOZUpVS1VU4Zu8zdK7Mlt3
         nKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680794942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=619nQ0lsEgEINdCEqk6IT2CyO/5/oumKn1+zUtFno4k=;
        b=Hamt+4c8IprS2ZKJz6FT6zRGQwB1gL0WhY+hMObRjaEXn9ChJUc22BkApHgJ1rAIXe
         A6uH8mYDGSNlsQAltLl/4kZnoAqs7U5kA8j7f37Gnmw9nKme/vreGGcx4dH2PW9nvKRG
         xZ431edBkwHUu65KP1AZVhkj2+n8/dWFgSrfmIEltNUygXlI50Ju9Kvcc2/EoTInia5g
         Lsny/oym2nauTGd74iTueQGh97yBoEJ3xERHnyltEVuEHL7QxHEJ5nbdCukcmB17cAPG
         UllKEeRstGiKPVesHfn7c1M/JxOuR0Pc+uK+dlAedv6y77PaVnMSvq5lVwsvzo6f3egh
         fESQ==
X-Gm-Message-State: AAQBX9eSjHtSQHydmzwWC/cHkYmiLiKUhaKT4VDq5cJJJ/6SBUxLd/ar
        7TWpK9iCP8+7RmBZvGEmA3xYusWsPa8WL6h6
X-Google-Smtp-Source: AKy350aL0d6vsdrWRXnaqUJo+aSZdHYPn8zOrCf5LeepDfVwSJ8pPtckKKR1Ack72MDaBZxWxYO5Ow==
X-Received: by 2002:a17:902:fb90:b0:1a2:9183:a499 with SMTP id lg16-20020a170902fb9000b001a29183a499mr9395030plb.34.1680794941673;
        Thu, 06 Apr 2023 08:29:01 -0700 (PDT)
Received: from sumitra.com ([59.95.156.146])
        by smtp.gmail.com with ESMTPSA id i2-20020a1709026ac200b001a4fecf79e4sm1318249plt.49.2023.04.06.08.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 08:29:01 -0700 (PDT)
Date:   Thu, 6 Apr 2023 08:28:55 -0700
From:   Sumitra Sharma <sumitraartsy@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Coiby Xu <coiby.xu@gmail.com>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Remove macro FILL_SEG
Message-ID: <20230406152855.GC231658@sumitra.com>
References: <20230405150627.GA227254@sumitra.com>
 <ZC2gJdUA6zGOjX4P@corigine.com>
 <20230406144644.GB231658@sumitra.com>
 <2023040648-zeppelin-escapist-86d1@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023040648-zeppelin-escapist-86d1@gregkh>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:57:44PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 06, 2023 at 07:46:44AM -0700, Sumitra Sharma wrote:
> > On Wed, Apr 05, 2023 at 06:21:57PM +0200, Simon Horman wrote:
> > > On Wed, Apr 05, 2023 at 08:06:27AM -0700, Sumitra Sharma wrote:
> > > > Remove macro FILL_SEG to fix the checkpatch warning:
> > > > 
> > > > WARNING: Macros with flow control statements should be avoided
> > > > 
> > > > Macros with flow control statements must be avoided as they
> > > > break the flow of the calling function and make it harder to
> > > > test the code.
> > > > 
> > > > Replace all FILL_SEG() macro calls with:
> > > > 
> > > > err = err || qlge_fill_seg_(...);
> > > 
> > > Perhaps I'm missing the point here.
> > > But won't this lead to err always either being true or false (1 or 0).
> > > Rather than the current arrangement where err can be
> > > either 0 or a negative error value, such as -EINVAL.
> > >
> > 
> > Hi Simon
> > 
> > 
> > Thank you for the point you mentioned which I missed while working on this
> > patch. 
> > 
> > However, after thinking on it, I am still not able to get any fix to this
> > except that we can possibly implement the Ira's solution here which is:
> > 
> > https://lore.kernel.org/outreachy/64154d438f0c8_28ae5229421@iweiny-mobl.notmuch/
> > 
> > Although we have to then deal with 40 lines of ifs.
> 
> Which implies that the current solution is the best one, so I would
> recommend just leaving it as-is.
>

Hi greg

Before leaving it I would like to know your opinion on the solution Dan is offering.


Regards
Sumitra

> Remember, checkpatch.pl is a tool to provide hints, it does not have
> much context, if any, to determine if it's hints actually make sense.
> 
> thanks,
> 
> greg k-h
