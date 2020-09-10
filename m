Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07152641B7
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgIJJ2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgIJJ1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 05:27:30 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9A8C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 02:27:28 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id c13so5289992oiy.6
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 02:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AXjh9C/kNxUf/B8KrB6TfCa9nbCzwj50lBpKn0K8wrs=;
        b=L0URLKFJZ5CvYwXLmija3xbn/OE0vl33n0Iot+zVBGL7NtaZ3a4KwrPnSVR4MKkVU+
         60/C+esop7KuR/kLhNaBQl+AVKTJ6T46kTDbt66PxJohEsyBKaIK9gRIsCgBSF/G0Z+g
         cjjT+6xc05iJenvULBefmJU9GJk1Lld7zdhBU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AXjh9C/kNxUf/B8KrB6TfCa9nbCzwj50lBpKn0K8wrs=;
        b=pXxsaw9ZWweICa2LNTt4eIjosUuH5Ec6I4WPF8m3/jJ1VtwBj2m1h/NknXpax1ilyR
         7uzOJXF1QdrMdMEQ3CXge5iF2UQ1cTjD6VMiaxJUxpxrZQj4jJmvFjAH/qyZzSp86MRW
         pLc7cXEfYEXgQzq7+FR8xWGMb1XTwbuz3cuiqW/iaaQflR9iCY4cp1m4UrTJUToF910A
         eE601MnO5LHGyVEbPLdlnotB32NKwv0p7CKbEA1xPuXYe+lu+gtPn8uEyELlA2TlBN0v
         eF11iE825pg02khennV5B6i8iSJ52Q6j9nfEtLWnbXg+0hKrB/RBc4rjMreC7PKRsNJJ
         Oi/A==
X-Gm-Message-State: AOAM530gMVgf8pCcw4x5pkrb2MFN2GuXOlwiePPaMwgS8oN6GqQID3xs
        C4jprC8IgxI86JXc3iwzQiAcFSDO5UXarbLrZ57Uag==
X-Google-Smtp-Source: ABdhPJwuIoldOVg99hAVhDJfmWfVNa9nwPqxDMQpD9c1sq7vaXNBohIVKadAK76hRiSQp+la3J6k70BhgO7Eiffgvio=
X-Received: by 2002:aca:4a4d:: with SMTP id x74mr2975313oia.6.1599730046959;
 Thu, 10 Sep 2020 02:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200909100417.380011-1-pbarker@konsulko.com> <20200909.112651.316991618642135494.davem@davemloft.net>
In-Reply-To: <20200909.112651.316991618642135494.davem@davemloft.net>
From:   Paul Barker <pbarker@konsulko.com>
Date:   Thu, 10 Sep 2020 10:27:17 +0100
Message-ID: <CAM9ZRVtw-+uoF+RkMCTrwf1d6kvf_UzHAgEXvcQe22zo+x522A@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ksz9477 dsa switch driver improvements
To:     David Miller <davem@davemloft.net>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 at 19:26, David Miller <davem@davemloft.net> wrote:
>
> From: Paul Barker <pbarker@konsulko.com>
> Date: Wed,  9 Sep 2020 11:04:13 +0100
>
> > These changes were made while debugging the ksz9477 driver for use on a
> > custom board which uses the ksz9893 switch supported by this driver. The
> > patches have been runtime tested on top of Linux 5.8.4, I couldn't
> > runtime test them on top of 5.9-rc3 due to unrelated issues. They have
> > been build tested on top of net-next.
>  ...
>
> Series applied to net-next, thank you.
>

Thanks David, and thanks Andrew and Florian for the reviews.

-- 
Paul Barker
Konsulko Group
