Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365EF6620EE
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbjAIJGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjAIJGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:06:22 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3821B1403C;
        Mon,  9 Jan 2023 00:58:53 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id ay40so5735726wmb.2;
        Mon, 09 Jan 2023 00:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X8k43ejWCwSThPb14PyffH1MScgx/Rj8NmhWD2SvdR8=;
        b=qYdZpujy0uVAYU5aoX/jiSqNOwL8KUnFkssUr33i8+mTMUEldErpeyp3EA4eZmQpwH
         J6+l5f+4aetzGce3oT8RXX2QvORNZXnLMrI0GKsy6oJ1LIhn5s2/H4WETzHb+9i3hJW3
         qWoaMUSBspPV91UI6GfJd23WNSF12pd28RlJ/2sOYd4TFDkSbPxpXMpxXVjm/zZHb0LA
         34Nqxkm0Stl8zXFcMHyNExwKxhyaEhL30yncVL0uzBlXd1F5qdVUwd6447TjAuSaDPeU
         Ito66XcGc5q0Filrno99M/0XZcZVfqBYVZ0+qYgM9D8inhjN9xaeB0F+P6soCrI79WAN
         B3yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8k43ejWCwSThPb14PyffH1MScgx/Rj8NmhWD2SvdR8=;
        b=rCOWaSs73lizjAIWjpqN6sIxXl6C8noBqGndysz6lFMZO4be3nMzMrXr9ZHkR7mda7
         iILdcJ0ioWWn2f6yv98rO8MY4MJPuHjZkuo1aGtyEpqQFRdiaa37qD7bFkyzKyuXC+2U
         DYnOv6+/zr9/gcWT68/9gKWD2iAlo9ME2IjSrNAVGSSsElaJhCtbB0GiQOSHw0TD8Liq
         q5S3ezhU0N+tT5BTFFZ0Itrw3YDqV1QxF3IcxxuM1G9QThb4HTLtR0vWJ4mpS5U3TSMg
         MV3U6tLStK0gdP2nCaLThAsNpcE+kslHc3QHC9xPXLkfazt4n3IISZ0n93SJ6WV25Rew
         Y2TQ==
X-Gm-Message-State: AFqh2kq6rjbEb0I6Y6JnYq45D/JN/RE+MVRLCUptPxDVg7SzSZ5xDx9e
        e4pLUrbUXct92rKw/JWAxgI=
X-Google-Smtp-Source: AMrXdXvJ/4X9WqA/3/op5IY4we4OL8jRADxlfOD2HPLUY30gMVw3fnauVEfNMHdhnNUKytb34Ch7PQ==
X-Received: by 2002:a05:600c:35cc:b0:3d3:3c93:af34 with SMTP id r12-20020a05600c35cc00b003d33c93af34mr55836411wmq.2.1673254731784;
        Mon, 09 Jan 2023 00:58:51 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e10-20020adfe38a000000b002bc7fcf08ddsm611698wrm.103.2023.01.09.00.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 00:58:51 -0800 (PST)
Date:   Mon, 9 Jan 2023 11:58:48 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        linux-sparse@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        gnoack3000@gmail.com, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        artem.kuzin@huawei.com, Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Message-ID: <Y7vXSAGHf08p2Zbm@kadam>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
 <9a6ea6ac-525d-e058-5867-0794a99b19a3@huawei.com>
 <47fedda8-a13c-b62f-251f-b62508964bb0@digikod.net>
 <4aa29433-e7f9-f225-5bdf-c80638c936e8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aa29433-e7f9-f225-5bdf-c80638c936e8@huawei.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These warnings seem like something I have seen before.  Maybe it was an
issue with _Generic() support?

Are you really sure you're running the latest git version of Sparse?

I tested this patch with the latest version of Sparse on my system and
it worked fine.

regards,
dan carpenter

