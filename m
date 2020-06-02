Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5338D1EB597
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 08:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgFBGGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 02:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFBGF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 02:05:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D552C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 23:05:58 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id q11so2059680wrp.3
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 23:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hz/g/FQ05/YdxHwBywYmuxWLTzuz1TJhFkBYR589LZE=;
        b=Ut82PhjkZUPhc8B9/o4g74QfFJRTYNNR3FQ1uZ7Cefk4JIr/vceLUMKAGDmIDF1Hwh
         +sQu8F+GEaSACj1eiHafdG7Y1eP73duZ5r460hQ2T/3jWXVD2IGhUf7ZK9/TJ26DdjQE
         ZuUutf6Un0c+ajJ56b8lUvgpHhT8Hdaa86sBFXwZYRQEWG/yrE32EM7p+6HwjS6MuEmK
         d3WGHwL4BVPp1CklSaEbG1UxM0SlXdRE09UCE6mI1yeVA+Q23QSoi4YOfxiwQf1ndAvG
         MTllUY0UYkQY4iG7qZ/FkdA/BzvDRnPvswUYtr/vHMFZKrZW47KZByDrgftnL3R3BLmi
         vKdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hz/g/FQ05/YdxHwBywYmuxWLTzuz1TJhFkBYR589LZE=;
        b=hXyL2/NJBnotJw09lVNyxpjkGaOFmkbv8GpzzxVRg3z3kQn3GSkuGaV2F9IyPlwD7a
         cjcKjtS+8P4lZKrROjabEjvQodTyQv9jQqt11bSJV8MF0z4eeiz74eCK9EslcOP7evfM
         sICa5qAW0MVMhnTpsvnb1FHdUCOJ0bpj7kria9d76+5AVmv4ceNXfwHGl9j35cqnAe3M
         0uWdPmEjolpmA8FhcdLtWqxAL4M4Te7oECnibEa2v+r+J+5kC/FjpFSjfpRGYEz0GHvd
         +r/LnzGbxWoT0Qm+UGLuPs/XzgsthzcUpleA+mYVQmN/i9/Tt8WNwshaG2C5f42G+ENc
         tmdw==
X-Gm-Message-State: AOAM530IiS6txumQtUHa15j0+Tc1ycNAM/a7dWw2YXB+9wZXFQdBp5Fy
        2Bl+c8FsotO8tZW0WPOeC2TZgg==
X-Google-Smtp-Source: ABdhPJy+U2bVNj56Q36xAd2jbpekROF3Zmkke1gwLcalG+0b6GDTGB96JLVEPVrRryaOaBla129yww==
X-Received: by 2002:a5d:4490:: with SMTP id j16mr26901818wrq.276.1591077956993;
        Mon, 01 Jun 2020 23:05:56 -0700 (PDT)
Received: from localhost (ip-89-177-4-162.net.upcbroadband.cz. [89.177.4.162])
        by smtp.gmail.com with ESMTPSA id o20sm2163095wra.29.2020.06.01.23.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 23:05:56 -0700 (PDT)
Date:   Tue, 2 Jun 2020 08:05:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Petr Machata <petrm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
Message-ID: <20200602060555.GR2282@nanopsycho>
References: <cover.1590512901.git.petrm@mellanox.com>
 <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
 <20200601134023.GQ2282@nanopsycho>
 <CAM_iQpXTWK+-_42CsVsL==XOSZO1tGeSDCz=BkgAaRsJvZL6TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpXTWK+-_42CsVsL==XOSZO1tGeSDCz=BkgAaRsJvZL6TQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 01, 2020 at 09:50:23PM CEST, xiyou.wangcong@gmail.com wrote:
>On Mon, Jun 1, 2020 at 6:40 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> The first command just says "early drop position should be processed by
>> block 10"
>>
>> The second command just adds a filter to the block 10.
>
>This is exactly why it looks odd to me, because it _reads_ like
>'tc qdisc' creates the block to hold tc filters... I think tc filters should
>create whatever placeholder for themselves.

That is how it is done already today. We have the block object. The
instances are created separatelly (clsact for example), user may specify
the block id to identify the block. Then the user may use this block id
to add/remove filters directly to/from the block.

What you propose with "position" on the other hand look unnatural for
me. It would slice the exising blocks in some way. Currently, the block
has 1 clearly defined entrypoint. With "positions", all of the sudden
there would be many of them? I can't really imagine how that is supposed
to work :/


>
>I know in memory block (or chain or filters) are stored in qdisc, but
>it is still different to me who initiates the creation.

Qdiscs create blocks.

>
>Thanks.
