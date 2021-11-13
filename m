Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E52844F429
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 17:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235923AbhKMQhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 11:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhKMQhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 11:37:38 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90BDC061766;
        Sat, 13 Nov 2021 08:34:45 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso19073432otg.9;
        Sat, 13 Nov 2021 08:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Xs95fLVJUY3C0IFeTkqDcpFuWgNY0YQGMTpxIUpLmLg=;
        b=m4gGM+sXRQARkbZ2e1u4jvRUD4gRb49E8MGcGgNbVBh9BesBxL/sboNaLQhPaRcPRD
         ibW56sg1uFIGxEHVxCjZ4XHHxKI/yVBWMmGnaV05gwfPckxeLfZ2S8j8yEmE7zRhXvC/
         qbOKrc1t5TYEpmhZiTvyfQuquKMhbAfD4aWmrwzPpSlFSk/pT1n9CcIV65U31wuGqjYP
         ejgKGVupnOTm3WTKbGPE1IgweS+cq8ufkfVLSOoQBvj/2mUGG4JcZ7KqeqiSkCPaWkcR
         gfsD2xodza45L8B+KXhi0HF2X+wv4uUgHzGdH+RFpOuHO4XESD27zWO8T6JT/HUvuFoD
         AWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Xs95fLVJUY3C0IFeTkqDcpFuWgNY0YQGMTpxIUpLmLg=;
        b=OTASz17H2j58GHmAznp9ZNGRHr+xa3EIZgavJjoIwCkFXjs1CkdCdGL01/5V4DznLs
         GAPFyRriHf1F+6/1YaaROOtZvN1X5W14cTat2fQsxcF6852AbmtFj5RmPpUfeYCt7RuH
         /yt+YOZljv6KjEOaD6usmXberyRRlh9quHeWyIOZBjHzixOjTD0WdAdd5zw7mFDIJ0LT
         VvNyqEv/E4hRkEWK0dIww6yqHae5J0VlieMCBAV7/o7S1yWP33pdFDvX99FSw3gLKJE2
         i2IrQksx3TZ3wDAMgd1XgmsZTdYGadCVaZEddLjvZI6C8Wsc1beWLWjAxfndLNA7Zm0B
         ketA==
X-Gm-Message-State: AOAM530myWiBYUb3mQ0VFztjC5fH4B3hjkFfwCQWARHv49B0Vv8Bj7Kz
        5DvDQ7efBH31Kw+/aCtqmTI=
X-Google-Smtp-Source: ABdhPJwditGxKVOEK4CG2QnPnEjJjGEO9l0ypPWMpFFnRKeOH4Q2YTupHDhplGfYSR8GlwevHfzW+w==
X-Received: by 2002:a9d:6394:: with SMTP id w20mr19793428otk.248.1636821284987;
        Sat, 13 Nov 2021 08:34:44 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id y28sm2058931oix.57.2021.11.13.08.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Nov 2021 08:34:44 -0800 (PST)
Message-ID: <de051ecb-0efe-27e2-217c-60a502f4415f@gmail.com>
Date:   Sat, 13 Nov 2021 09:34:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH net-next] ipv6: don't generate link-local addr in random
 or privacy mode
Content-Language: en-US
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Rocco.Yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <20211109065526.16772-1-rocco.yue@mediatek.com>
 <20211113084636.11685-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211113084636.11685-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/21 1:46 AM, Rocco Yue wrote:
> 
> Gentle ping on this patch. :-)
> 

you sent the patch in the merge window; I believe it has been dropped
from patchworks.

Also, you did not add v2 (or whatever version this is) with a summary of
changes between all versions, and you did not cc all the people who
responded to previous versions.

