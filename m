Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3AD662318
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbjAIKXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbjAIKWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:22:50 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855381BC84;
        Mon,  9 Jan 2023 02:20:43 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d17so7637088wrs.2;
        Mon, 09 Jan 2023 02:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QAOFQ4yPvln4j2mWW6RXQivyGefx9gCvSrS9I1Bu9Vc=;
        b=otUK4XRZzSqrfbL9qrkSrDDDv6EKJ289TU1bfBgfAWWlNdtt4jXtq0E3hp3E8yg8uV
         vCQw626c0N3DUr50L2GhZvbXZwLlotyDkyDXHHZlMZFm7Emr92UDvd64n64w5lkccUE3
         E4r/S/I5XHMmBpSwx1ee5geX4Acz/+pv0oOKzfX3++xRj11ZXQfRYshRGA8ds/7FGx79
         uF6rbSpOmM0j56GiZ6g/V+yp9F8+SgyG+k4JNArZqldbwQRShwa4878FBN6tcAOkVv2l
         HHR2kqZT9IbVTjufdF4OrYYU7B5VS89Eb1xjAMI2OvfoeK34BxOHDLiFAg+gZmmJPgqV
         d1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QAOFQ4yPvln4j2mWW6RXQivyGefx9gCvSrS9I1Bu9Vc=;
        b=mpirlmYroL7ezjMumPIpXywlPAl55esjnq5n8AsOwox2GA/cJ3Xzs0ykCnvVC7xkM7
         WQ9d+PidbZ0BktahITvPUouwjxh1APT4HDte9+JS/fGO949UZlfpVCybWgPYA6r7W95Z
         EmBFOFzAAA+MFbqD1cEIYTMgfI1G35ySnbDg7mCwJtT8gmJ+3jW1UGY5o9RGYd2ttEbP
         jHN8AML/vFzS/WA/W7gWMWgCWOjr0pREcN2m9h4R0vyE4BzuqozLMfrX8yP4eNR844Ku
         889LLP9dDKIqHd9Z4nHWCK7AxX8oZfxr8P7NvZS8vNKg6le1u63KXoq3NX4I3yFEMG3S
         zywA==
X-Gm-Message-State: AFqh2kqqk908xskEEDdcV26x1zLwQtgtGTeQ+H3zuUyDTplgGSsRBBkR
        iKtp6s5Ymacabkj1icRhB0k=
X-Google-Smtp-Source: AMrXdXtwaCa9tlfVWo8lcSyfXwvjGvNczjYfypBU2d8oTIoMSlTO+k69LgPCvRsJ+bpOnfyWD0I9Ow==
X-Received: by 2002:a5d:4b85:0:b0:2b7:f2a0:6d9c with SMTP id b5-20020a5d4b85000000b002b7f2a06d9cmr8182173wrt.41.1673259642044;
        Mon, 09 Jan 2023 02:20:42 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id d20-20020adfa354000000b002bc50ba3d06sm2189056wrb.9.2023.01.09.02.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 02:20:41 -0800 (PST)
Date:   Mon, 9 Jan 2023 13:20:38 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        linux-sparse@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        gnoack3000@gmail.com, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        artem.kuzin@huawei.com, Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Message-ID: <Y7vqdgvxQVNvu6AY@kadam>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
 <9a6ea6ac-525d-e058-5867-0794a99b19a3@huawei.com>
 <47fedda8-a13c-b62f-251f-b62508964bb0@digikod.net>
 <4aa29433-e7f9-f225-5bdf-c80638c936e8@huawei.com>
 <Y7vXSAGHf08p2Zbm@kadam>
 <af0d7337-3a92-5eca-7d7c-cc09d5713589@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af0d7337-3a92-5eca-7d7c-cc09d5713589@huawei.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 12:26:52PM +0300, Konstantin Meskhidze (A) wrote:
> 
> 
> 1/9/2023 11:58 AM, Dan Carpenter пишет:
> > These warnings seem like something I have seen before.  Maybe it was an
> > issue with _Generic() support?
> > 
> > Are you really sure you're running the latest git version of Sparse?
> > 
> > I tested this patch with the latest version of Sparse on my system and
> > it worked fine.
> 
>  Hi Dan,
> 
>  git is on the master branch now - hash ce1a6720 (dated 27 June 2022)
> 
>  Is this correct version?

Yes, that's correct.  What is your .config?

regards,
dan carpenter

