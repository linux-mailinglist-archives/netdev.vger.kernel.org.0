Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9006BC8B6
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCPIQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCPIQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:16:22 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E9DB3E37;
        Thu, 16 Mar 2023 01:15:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso792566pjb.2;
        Thu, 16 Mar 2023 01:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678954474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lh4NaocRUTHfBtuFcWJ6twO4Zfej2qsZbIvJj6d8YrQ=;
        b=i2dPiNUakVTV07nSePo6/QTB2zmetVxWwtR37oxPvsmkQ33oGrVtwj6hoawCbMkzgn
         ywIVt+Xkf1Hyh8/bPiQKGtLxC6kcTFEMPo3kvQ9Lsck3rjXH1Hn663vnIpL4FpWgMS67
         KJ1eucw+KCt6o4szzqFAHAr9CinokgukMUP9Qto9RkfsZrL3KN/sSjBe4yxOx39HE0F8
         Rx4l1Twgn92r4cLblq3pyhqLWLUi5DCP1ZQ/H2B1IIxh1YDOq+31+JzG0P+XNebW4D1T
         KqEPQH64Ji67J8QCyXVjbONWmpFaI6D1Dl6U0KuBhhk6jqW+vQFCeF8YGyu8sCfSu3p0
         N2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678954474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lh4NaocRUTHfBtuFcWJ6twO4Zfej2qsZbIvJj6d8YrQ=;
        b=MvC84MIJbLV3hZvbYllZb0B4Vomaw+3IcL+Icp6g7b1vmOtU6Zc0RTYdbr7Hq44zut
         kAmjjVFLXxsw8jBb2RjIJjBC+5HzTj8XEDvkoMT35K/IXjHmcl2QtwzmmIlu+cUeASk3
         BFumOeDUxBJOKP3OPuHqb5r2hcRReMFcsb8GGOuJnLmgWDpCCG2hruZywyi6oo10FXfL
         hvXZGMQKafV4F4QDSeNvuKOQc839NuriA2yzfZ2HY9McQtMHdonaNk1sUztlOfCoBrw8
         L28+UWzpAm6EIo0Hm6Q719aHYpt/yC2+pgVx4pTdLCJT1TlSBul64VeyzFksM58Dx9ZB
         qhIQ==
X-Gm-Message-State: AO0yUKW8hmCg6CXFzNs2J/YCC2XeaAzBk1xeyazcVxUxLpfmu7TGlVn4
        5Sd8tfB6wU6Z2rkEJLTSx/I=
X-Google-Smtp-Source: AK7set9pK2paw7m6Dctu5vfldLJKD/kpmus/xGzcGEfYNWs6eliMciSGNGbihG6unFbcG9p42FaGQA==
X-Received: by 2002:a05:6a21:3385:b0:cb:af96:ace7 with SMTP id yy5-20020a056a21338500b000cbaf96ace7mr3280065pzb.46.1678954474219;
        Thu, 16 Mar 2023 01:14:34 -0700 (PDT)
Received: from sumitra.com ([59.89.173.232])
        by smtp.gmail.com with ESMTPSA id s11-20020aa78d4b000000b005ccbe5346ebsm4773152pfe.163.2023.03.16.01.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 01:14:33 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:14:28 -0700
From:   Sumitra Sharma <sumitraartsy@gmail.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     outreachy@lists.linux.dev, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Staging: qlge: Fix indentation in conditional
 statement
Message-ID: <20230316081428.GA47053@sumitra.com>
References: <20230314121152.GA38979@sumitra.com>
 <6e12c373-2bfd-48d8-b77d-17f710c094f7@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e12c373-2bfd-48d8-b77d-17f710c094f7@kili.mountain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 10:47:21AM +0300, Dan Carpenter wrote:
> On Tue, Mar 14, 2023 at 05:11:52AM -0700, Sumitra Sharma wrote:
> > Add tabs/spaces in conditional statements in to fix the
> > indentation.
> > 
> > Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>
> > 
> > ---
> > v2: Fix indentation in conditional statement, noted by Dan Carpenter
> >  <error27@gmail.com>
> > v3: Apply changes to fresh git tree
> > 
> 
> Thanks!
> 
> Reviewed-by: Dan Carpenter <error27@gmail.com>
>

Hi dan,

Will this be considered as my first accepted patch? :)

Regards,

Sumitra
> regards,
> dan carpenter
> 
