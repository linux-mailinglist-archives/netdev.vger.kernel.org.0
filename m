Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344F52CDA6C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbgLCPxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgLCPxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 10:53:45 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2747EC061A51;
        Thu,  3 Dec 2020 07:52:59 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id 7so4221312ejm.0;
        Thu, 03 Dec 2020 07:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CXaOnVHE8T8HRHzyFS8MOeAflgZRNwrRsw02ZbnPA/A=;
        b=kvcUtenvDRvgGrxf2gmWcRt4FaLjG9raTjaxS1JxavZsHW+RD1VwblPtIZJJEe7BS3
         UiFeKtcClxjYcV86I+WuMlumUGHb1++LLUjSGATa3Iwsi6Qa3esRzg+aUZuAFBVDh2+D
         6JwgwgU/d/9dQvt8Mb+7tNXMb4SWaoPTa1SNh33wrqNE70SylFfuf9P44/pHIj1+Ykfq
         HcRwVSkiTVT4TFTDZPBrfCKBGT6KS8lMCSXhdxYnEF6mGYYi6RjLsAm/AamI6OCWL3EV
         u73ZiaRvXf7vLUwfF8mxXaJFCEYshI0cuN/B6ZZbuSALoZtLJH8iIIQvmDVPbIdDFIBf
         srYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CXaOnVHE8T8HRHzyFS8MOeAflgZRNwrRsw02ZbnPA/A=;
        b=kImQJi+YK567yoiqa4Rk3j2nHRHYJ96psMg+L6z0Vmk+OMrln+y3M30T9wNviSQo8d
         LsigpQxhwLrHHje7aoDUA7gIMDHBgbl/vqCgefn2R9PActmhrXaEPDrZ4k8ANlm++DB0
         c+Pq0MGp+4HsHBb93VTAGSCcZ1XzqyfsgVjruHGqzjW+0qWEn8gFWzpOt0S1fWtJlZ5v
         wsikxc4w+hlQLUrk19UOadVnnyaswj+gXFeUjuaW8xT6VCvCGap8ImT7p1elrGbBdl5Z
         K17g4rJRk9eK8W3ZLSx6BDUu77PQzA/XeObuboEkUWlssNabCc9h9Wc6UeJbyZ7lPm6+
         m0Qw==
X-Gm-Message-State: AOAM532vFyaERVJ9NSoxjUvJQ7HTaUxueakrcin2aZ2reP95uFsE+hmz
        6osypGQIA3G2U7b6JsIUlwnj5X8plq7vS+joqpM=
X-Google-Smtp-Source: ABdhPJzYPagC+YWCDS7JeC7C71D0rcIOVj8nB+8JIuvmHdWYkMFKitHtXYpRbkaBYmj1rtSMjvnfa19szhzwmfbKcik=
X-Received: by 2002:a17:906:b306:: with SMTP id n6mr2970752ejz.473.1607010777863;
 Thu, 03 Dec 2020 07:52:57 -0800 (PST)
MIME-Version: 1.0
References: <20201203102117.8995-1-ceggers@arri.de> <20201203102117.8995-10-ceggers@arri.de>
 <20201203141255.GF4734@hoboy.vegasvil.org> <11406377.LS7tM95F4J@n95hx1g2>
In-Reply-To: <11406377.LS7tM95F4J@n95hx1g2>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 3 Dec 2020 17:52:46 +0200
Message-ID: <CA+h21hqtgaFOgiSdho879ZfaRsMtp44kcFuq3zyW4Jb811gPSw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 9/9] net: dsa: microchip: ksz9477: add
 periodic output support
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 at 17:36, Christian Eggers <ceggers@arri.de> wrote:
> Should ptp_sysfs be extended with a "pulse" attribute with calls
> enable() with only PTP_PEROUT_DUTY_CYCLE set?

Use tools/testing/selftests/ptp/testptp.
