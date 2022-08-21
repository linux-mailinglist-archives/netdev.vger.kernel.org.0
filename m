Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF45C59B5FB
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 20:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiHUSTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 14:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiHUSTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 14:19:13 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E3A20BDD;
        Sun, 21 Aug 2022 11:19:12 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id v12-20020a9d7d0c000000b00638e210c995so6322275otn.13;
        Sun, 21 Aug 2022 11:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=5BUr+pdJQPDU+d4hf/5/BNFAwZYtBy4pYlxFPXo1uzk=;
        b=ZZpIKhjqg6k/G8ASvivkfbt3yKbKQsqM8RpmqYv/R9rvhDo+MMUIAyRHmv4v+8d5XI
         c0jz1L1bxV90+blLYRBSrOtOl9JlUX7Tx4xXedmW0X102gntjkBqQSbusHO9akiwvCrt
         8///lPePuJ0fcz7UNzhm9Gux1alyDyW1B0Rj3RTwdIOrF5DomnqwKvFtd3Gu6BW5Tvme
         FcS8M5FW7uNisNbyuth45NLFbYJpFq9DHuc+8IG1yw3gjb9+IGjylRMtjkh2LxkQoP9w
         Gm88+nV09gp2JzSkLhnIHD6n28HPaHr3O9pixt9gISfTjB7ku/ko9+fa20GTBjLo+yBw
         VVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=5BUr+pdJQPDU+d4hf/5/BNFAwZYtBy4pYlxFPXo1uzk=;
        b=8BYPOqnqqgV2lRxvk+eag+V2QNFZ+ayTG4IRy3TOg/0F/sVA8R/KWz5LMqy8Qu5HXr
         EWYHpmmlFOr5rbimbT7rV3+6nMn73Fpc/8RCZYWK7UnToNcgmc6sT3Dz8PSxPNwpniMM
         1pLOrYjPISXZ3G47rgQGnurWK+3DWBC//Btan7b1FWIoV/xk2UILb1Yii9XjMN9rzd1T
         rlgUeKkMOmf7Or2WOVQdW0CycEDFWZTjeHxovgkfvUaisKWXmw29C3LIOHLzwo7U/9Pq
         kMbxSd0S9iRXroRrJm7iR1axJ4THTDgCdf7JmphV9+nIKk0uLXWrKl9ZnrB/Xjp3ShyF
         DLhg==
X-Gm-Message-State: ACgBeo1A49ET0hOZ2NuLRLYoDnjFZTXT74V3y3tPj7bGVlK3znABPmr8
        cPFajTTaECxbpKxCY1Llchk=
X-Google-Smtp-Source: AA6agR7K6N9TH8smsbvayiGDeRfxJEkw165nT67CO/c9bjiNFP9y4znUTknDYDw7HS/u0bV29+Xm9w==
X-Received: by 2002:a05:6830:3142:b0:638:d079:74fd with SMTP id c2-20020a056830314200b00638d07974fdmr6522926ots.129.1661105951758;
        Sun, 21 Aug 2022 11:19:11 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:3176:b577:754:c8d6])
        by smtp.gmail.com with ESMTPSA id o31-20020a056871079f00b0011cdfa748fasm1568450oap.11.2022.08.21.11.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 11:19:11 -0700 (PDT)
Date:   Sun, 21 Aug 2022 11:19:10 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     lily <floridsleeves@gmail.com>
Cc:     ziw002@eng.ucsd.edu, lizhong@ucsd.edu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v1] net/ipv6/addrconf.c: Check the return value of
 __in6_dev_get() in addrconf_type_change()
Message-ID: <YwJ3HufZK/784UQc@pop-os.localdomain>
References: <20220820102434.995678-1-floridsleeves@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820102434.995678-1-floridsleeves@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 20, 2022 at 03:24:34AM -0700, lily wrote:
> The function __in6_dev_get() could return NULL pointer. This needs to be
> checked before used in ipv6_mc_remap() and ipv6_mc_unmap(). Otherwise it
> could result in null pointer dereference.

Its caller already checks it:

3689                 if (idev)
3690                         addrconf_type_change(dev, event);
3691                 break;


