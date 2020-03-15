Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB40185E99
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 18:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgCOQ5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 12:57:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38460 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbgCOQ5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 12:57:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id x7so8205311pgh.5
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 09:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w2Y6grcKDpz7illvrAW0RS+fL1UuedzjiCjl5RFGUZY=;
        b=q+H02gPwC4Uu5m/Tm0sZi5veVeZVJNesBGspjRxbVa9nMsObwVxjWen3qoVQmslSZz
         2JGjfbYabU2f3ABEzeeuUHqhmf3dPyOAJJ2e0cS5SZIhzOaTpnr2Dq/AjFYIQZEzhBo9
         Zfl+ecs6dV7s5X848y7xVAKxuo3GLi7zjOgNzVAMUTBgODLztN1TPQkgGdZFoeBcqLv5
         P4CrMR3+K3+7zaNP1ngHDydklz9AwKNRbgufxAV9dpR78o3TCj4kRKj4aKnCvg0hoFW6
         /5a/QVGs6noPs/jUqDo6DWlL3Q4QRcWnqlQWTcwYApm/vnPdgI2lNS1+Mtz1VJVV92i2
         1HLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w2Y6grcKDpz7illvrAW0RS+fL1UuedzjiCjl5RFGUZY=;
        b=QyoDH8xN48rOjCpmG/noL36z/vV7tErfYTdRPyWN3xvDpDcWuY//1iSoSGqqFSv9kq
         njgxOHMVDarVYMRzCpL2qn9Lv000Yz/w9UkruhMGmiPqTfI/afqGW/xnWJdO0a7uErUH
         5eT0EN2cyAR8mECVPPz5B9/84LWuYXILLEaE4h68MX0A2IhWKU68piFr/pK9+NUMbeoD
         9ys+08AGaQfA52jRgJg2WddKLyscjJ+MfZSxOIisyrmr5OvW7rLIq5DRErsRDgpm47iv
         OStZ8sICFr0a5TDGhuLx9Qvg9D6w12pkXA+LLR77MRTz89yD/n55ehzpZ9OldLyNv8lB
         7mSw==
X-Gm-Message-State: ANhLgQ2C+d/eGeOEhN/GLUSUMNUNCHCxaOx/lYcXjMqTiKeKRIYGpEiq
        K1V+q9wL0Gk3z/4JgJI6DIBPOQ==
X-Google-Smtp-Source: ADFU+vtP+58YlF2n14rhKTpqccbtajedmHrv5VPfloCje4cNZwCaEoBL9WspbSQ1b/q3Z1NYv5NkAA==
X-Received: by 2002:a63:ed4d:: with SMTP id m13mr22645305pgk.350.1584291455108;
        Sun, 15 Mar 2020 09:57:35 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id l67sm11513996pjb.23.2020.03.15.09.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 09:57:34 -0700 (PDT)
Date:   Sun, 15 Mar 2020 09:57:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] iproute2: fix MPLS label parsing
Message-ID: <20200315095732.034b64e5@hermes.lan>
In-Reply-To: <13e1c79da12f9c08739e1ba94361d203e2a6627d.1583939416.git.gnault@redhat.com>
References: <13e1c79da12f9c08739e1ba94361d203e2a6627d.1583939416.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 16:16:36 +0100
Guillaume Nault <gnault@redhat.com> wrote:

> The initial value of "label" in parse_mpls() is 0xffffffff. Therefore
> we should test for this value, and not 0, to detect if a label has been
> provided. The "!label" test not only fails to detect a missing label
> parameter, it also prevents the use of the IPv4 explicit NULL label,
> which actually equals 0.
> 
> Reproducer:
>   $ ip link add name dm0 type dummy
>   $ tc qdisc add dev dm0 ingress
> 
>   $ tc filter add dev dm0 parent ffff: matchall action mpls push
>   Error: act_mpls: Label is required for MPLS push.
>   We have an error talking to the kernel
>   --> Filter was pushed to the kernel, where it got rejected.  
> 
>   $ tc filter add dev dm0 parent ffff: matchall action mpls push label 0
>   Error: argument "label" is required
>   --> Label 0 was rejected by iproute2.  
> 
> Expected result:
>   $ tc filter add dev dm0 parent ffff: matchall action mpls push
>   Error: argument "label" is required
>   --> Filter was directly rejected by iproute2.  
> 
>   $ tc filter add dev dm0 parent ffff: matchall action mpls push label 0
>   --> Filter is accepted.  
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks
