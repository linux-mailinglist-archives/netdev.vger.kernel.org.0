Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6B01FFEF3
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgFRXxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgFRXxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 19:53:41 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11149C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 16:53:41 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id o4so4027730ybp.0
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 16:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XfA2vpsTvAx+sH2kwtUr7DSSpefvNgfSxzsg3LMcc8k=;
        b=hIDBh6eO2p3WiU9TulbPMldJmakg0OhO1rFqwVbdZVGC1Jy68YJrgq5d+L9HPB5qE8
         zzRjsU/NrESvOcJOfevmRUPLW4mzkpzxHvMc/6V9rchUKyr/5vwcZf31uAmuq1rDCvYe
         07DvTXWEfNM1ALhbVU8oVEI9EpSc5h1zVCgovksaAeKMu6/jueE7mfdbe7e6udqJO3rd
         R/Lg7ENAZ2fNA5H+rSldfB+VxUKLKfncDYudA2+c3abn3Tlm56Wo/aRdsOeG4dkqgbgA
         WKHVAQHrfcZq0noK8wy0o86XLwkRBSJ46D8TU23b3/CsK9aH9tlLLeiUFJiYiSu6bzeA
         a7+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XfA2vpsTvAx+sH2kwtUr7DSSpefvNgfSxzsg3LMcc8k=;
        b=qXJ3v05qu0IHArEJxJ/WmYjwrHBkAOTVLlHGUA2bvkqLTACN0E2RExXGfWPPXAK2PC
         0HVgZKbVVkPcGQyfOwvGBaGbIv8lpmaGtRYBHxBRFld8y+ynwethbRVH20ojxC87/UGd
         KKgm/ELuLevfGJRD2BU/IZ5Vc0O7CjV487jEz27y47ZGCakg+RPqDwgqIOTbTxjzyTfb
         EUg4ByDjVwETRrsoH3eb6J+Dih6tqmw4Q0da0/OyoeICbSehtkeBHsXkpwgEEbrnUzIV
         joJrJ1pGA2crD9r2r51yEBbNKrvIhj30nVtlvfwS40EGNTosnF+P1i4VKdUR1lYCSBnq
         ijVw==
X-Gm-Message-State: AOAM530VFAwch4RtN+y8BA0OWPw2RwMeeqblyHRdm0Qz99VJg7VN7196
        pm0fySsh/joGDU+snIONuZj1QqY/b86M6lYNzSUYfj9n
X-Google-Smtp-Source: ABdhPJwBN9EG6niuZD/dPOVi+Uv6aWKrTWbG+gE1OC4lEtbsmtnwlEWXeqR4r9YdLA8OpctIcRoJsMTCmI3sIkDA6qM=
X-Received: by 2002:a25:b8c6:: with SMTP id g6mr1935133ybm.101.1592524420149;
 Thu, 18 Jun 2020 16:53:40 -0700 (PDT)
MIME-Version: 1.0
References: <159251533557.7557.5381023439094175695.stgit@anambiarhost.jf.intel.com>
 <CANn89i+3CZE1V5AQt0MA_ptsjfHEqUL+LV2VwiD41_3dyXq2pQ@mail.gmail.com> <b943b5d1-aa71-4eb2-ee77-d3c56cdf494a@intel.com>
In-Reply-To: <b943b5d1-aa71-4eb2-ee77-d3c56cdf494a@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 18 Jun 2020 16:53:28 -0700
Message-ID: <CANn89iLgj16S_J1bY6gQ8gjduMDcbgVx2OpPfUBOdmPeerH6Tw@mail.gmail.com>
Subject: Re: [net-next PATCH] net: Avoid overwriting valid skb->napi_id
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 4:44 PM Nambiar, Amritha
<amritha.nambiar@intel.com> wrote:

>
> Thanks for the review. Should I send a v2 with this change?

No, this is really a matter of taste ;)
