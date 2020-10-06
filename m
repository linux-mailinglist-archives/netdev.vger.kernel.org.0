Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9973E284C94
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgJFNcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFNcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:32:25 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F620C061755;
        Tue,  6 Oct 2020 06:32:25 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ce10so17649004ejc.5;
        Tue, 06 Oct 2020 06:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7VmO0GWEeQu+5/FHhJJ0ViDsI8bgkt7sXQ8SBKLqT7Q=;
        b=CEsWyuLIG5cUbt1LkjWL2gKqTVVrxHXaxRmy1UKeZUmroje5umwxXGVY+9VCw41pts
         aKWjhl1pfzli/PnJgfE+7TrV+PjXMyW0Lb/GJlT1L6xxdOUmqtYluEAvSLgDq2VlGZkW
         /0+qh7fUf+BsaGUmX589Vy4G76c7XC6HZtlPwsI0te/bZ8Rm/rJxhkSkJ3OdfVk/RRMA
         pcKbQidhPV5eorIw5Zu4aujfU4JTdha8pQMWzGs1RafcYMjxA+ZfdDtqEmUqX+fVd+aW
         dUPVSl2EYcbty1P5WvWADizRJ6IiEreUSaIRSeuTxFte3cyy5/Ye6z3sB/QL4crivDOE
         HVuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7VmO0GWEeQu+5/FHhJJ0ViDsI8bgkt7sXQ8SBKLqT7Q=;
        b=lFEXIz27WKW7gBoSUbvnOenQ6wFDSSlNtxylqgjHoY+tGtgN2ovDBD3jUpOw1j/xWU
         793wNqKKUT4VKEXTEjMJFGbwCx43E7dYSekviUTyTojdS98vff28L/dLXQ0hXTBiJhli
         JsfUEuf0fn8eW2N+nwtZiUcc92qiIr2o2QHG4D9Pee8Yt6+zSo2mMPYBpjq+hSS7LHc1
         hv3Nzpo73f57FZ9eZ/96/Uw4PClL4olr4mGRXNwQCebASmRv8EDe7h+Hq6S/k4wPL+Ah
         L2x92vJ0UDhvXRMdfyuGf3Vv/pgmWxQ9XVrwKd3rB5JUnpL2XLwHxjw858PPkwURlTG3
         g9Sg==
X-Gm-Message-State: AOAM530ZGXPp4v2/Y8AW1QCG17zcPYLO8jVw/tnW4pP8sHUC/CX1HhkV
        /duALudjjAlckmPlXmGHcoKr1btuC/U=
X-Google-Smtp-Source: ABdhPJysYa/u3LR8k8bykfaXy3Y6WLk+DXq33UTpn06SBE9y8brg/in3TFydx4MYkAlVom0us2ej6A==
X-Received: by 2002:a17:906:2962:: with SMTP id x2mr5220083ejd.188.1601991143873;
        Tue, 06 Oct 2020 06:32:23 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id cn21sm2318593edb.14.2020.10.06.06.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 06:32:23 -0700 (PDT)
Date:   Tue, 6 Oct 2020 16:32:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
Message-ID: <20201006133222.74w3r2jwwhq5uop5@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-5-kurt@linutronix.de>
 <20201004143000.blb3uxq3kwr6zp3z@skbuf>
 <87imbn98dd.fsf@kurt>
 <20201006072847.pjygwwtgq72ghsiq@skbuf>
 <87tuv77a83.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tuv77a83.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 03:30:36PM +0200, Kurt Kanzenbach wrote:
> That's the point. The user (or anybody else) cannot disable hardware
> stamping, because it is always performed. So, why should it be allowed
> to disable it even when it cannot be disabled?

Because your driver's user can attach a PTP PHY to your switch port, and
the network stack doesn't support multiple TX timestamps attached to the
same skb. They'll want the TX timestamp from the PHY and not from your
switch.
