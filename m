Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E0B30E2B0
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhBCSlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbhBCSln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 13:41:43 -0500
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28B6C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 10:41:03 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id i3so86207uai.3
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 10:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nCfy92LUQMSR0pWXdfPHHZ43OQ5n+8nIw7pUTilHQt4=;
        b=HvVuRSuDwf26RchcOawBS/s2Y0zc0XDrk1+91UPkqsbMivQbdzwwkxEec4x0eRAIls
         K+VphxU3bQzSOD+q4giQn8gjm64rRYK4Zc0crYia1BIJli9Zelofjl4YUVtd9qOfa9id
         Xkt+nVHS/eH1njSnt/wYSr/+g928BRhH2NgF0Mfc8tPuWK1zICBVM0lzPW41g7wcH0Up
         4EQePlJIG7ai2u4xrpWSLe9RmRsNSOn5bMiIgwsN7QDv72+boYCZ0z/sEmr9BXubuK7n
         cMHXMTt9qXnL33bc7fLomE+sUEoLYA4DVO2oFXeMYsu+uYnnrc667xkFaxVUw4y9DkuE
         EgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nCfy92LUQMSR0pWXdfPHHZ43OQ5n+8nIw7pUTilHQt4=;
        b=IWvz/zI4RIXmw0q+F8i7sq6rZjLiLwfv/G+o8X+ZPhVLRsV0m1kqKU4U2XLWKx1skc
         tquXMHN1xFzmRRkx8kJW1b+6Ei8PmvhR2/jGyI9JByxbwgf5b0KArsEj3FClo4+XNNi7
         W2xqPmJk+T+yjK0OIITnhNqqUJCWXgBnX+IipYirO2662lkAqC7rOWB5JySWlLI8kelv
         g3Jf8J4EhEldmVba9f0SaJS8fYl+HLq88jv9XDzH7t9VlPICw/HO8pwRVSTRYBHw3QFu
         kfeCHe8I13K8gojjQ9qhSXBW1iAjsozmLfGf0hxR8qsTdKGlQDOKUOIea01MqZPB4qsS
         06DQ==
X-Gm-Message-State: AOAM533iR01bTZ4Hi/njnBOGw0KRh3meq8Nbp3RaYx7Fp3kmbUt1tnfl
        i9UHOoyEn3UlqICUqvl1PvN7ce6PA0k=
X-Google-Smtp-Source: ABdhPJwM/bcRO1LYZSDt+ofx5Au+Wog7Zihh4Htxzl9dR2zh20QPzbUHpdYzm5hh2q1UjqvhaHvY1g==
X-Received: by 2002:ab0:6785:: with SMTP id v5mr2952210uar.72.1612377662534;
        Wed, 03 Feb 2021 10:41:02 -0800 (PST)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id f85sm378995vke.2.2021.02.03.10.41.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 10:41:01 -0800 (PST)
Received: by mail-vs1-f53.google.com with SMTP id p20so407594vsq.7
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 10:41:00 -0800 (PST)
X-Received: by 2002:a67:f94d:: with SMTP id u13mr2722695vsq.28.1612377660410;
 Wed, 03 Feb 2021 10:41:00 -0800 (PST)
MIME-Version: 1.0
References: <20210203050650.680656-1-sukadev@linux.ibm.com> <20210203050650.680656-2-sukadev@linux.ibm.com>
In-Reply-To: <20210203050650.680656-2-sukadev@linux.ibm.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Feb 2021 13:40:23 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdRci4=fAza+L_-kUf9VkZnfUhWZ49-XHY8DiRuroSv3Q@mail.gmail.com>
Message-ID: <CA+FuTSdRci4=fAza+L_-kUf9VkZnfUhWZ49-XHY8DiRuroSv3Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ibmvnic: fix race with multiple open/close
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 12:10 AM Sukadev Bhattiprolu
<sukadev@linux.ibm.com> wrote:
>
> If two or more instances of 'ip link set' commands race and first one
> already brings the interface up (or down), the subsequent instances
> can simply return without redoing the up/down operation.
>
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
> Tested-by: Abdul Haleem <abdhalee@in.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>
> ---
> Changelog[v2] For consistency with ibmvnic_open() use "goto out" and return
>               from end of function.

Did you find the code path that triggers this?

In v1 we discussed how the usual ip link path should not call the
driver twice based on IFF_UP.
