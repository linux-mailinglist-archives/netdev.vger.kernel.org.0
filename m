Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC2F666EA
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 08:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfGLGVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 02:21:45 -0400
Received: from mail-vs1-f51.google.com ([209.85.217.51]:35208 "EHLO
        mail-vs1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfGLGVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 02:21:45 -0400
Received: by mail-vs1-f51.google.com with SMTP id u124so5996187vsu.2
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 23:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KVzpvFXw62nZ+n68ur6hZJT1QE9b9v3Bm8b34c0K7wU=;
        b=qLOwQKB66gzhECbPl/MU1moUFcEx6cxnK2YLt7DWcRWVi2qHqORf+c0mzFDZjvKqrY
         ZM1YdxKHEmjhW2KlJ0n1jbhUuuiDltKMzxV0Xzw5IOQmyeLB1/tLHsG683dFXFLqcY8Q
         7Zcse05OsekM13l5cigB9SCkQL4Yb/nHDZWziOY+3Rnm9UqAUvrN3i8Pf0nerjs1dQ42
         P8bRB5zS+6z3wGV58Bxs9rucYi5k8j9hx4SFcLrQAKKEfQlS3bEYZlIx3fsjRR8qmVE6
         gTjxnKXthEs6PBbh6NppTsxepGRmiAwqzVEzhlyeg7qegvtip2oEpVPbO72ntQol0rJp
         nj8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KVzpvFXw62nZ+n68ur6hZJT1QE9b9v3Bm8b34c0K7wU=;
        b=irIyUmAfeENumyqo7TA9b1jkbXcFXTw8IErk6DBO8pDYg/wMkiu8VKM7ecjNlYPTwT
         XeY0brb+IFXOAufRkplvRhrO2dGlDeuRakUWIELztQzuy0YrIR/qmPgAlx4UPEAuy81J
         PV0qsKLT3YQQkJgFNc/C2qnBACpYCdiSJ0mTt981Yp4j6BDRx1AeJyzWVr5uij/2P/gA
         0tSOfoWjmV2CEnfVBd6t8bXuk39lrqxQl1EwfByaqHszYYnzgwN6UA5C+x03KvuOQqFF
         ukVeU1IpCFsTeuKpKUHFX/FlS3cAyd6u6T2HEBcxmpq7K1FG8VlHLQO2RMaEkts0sWW4
         X76w==
X-Gm-Message-State: APjAAAUzQ851f4Ry+zIwkRFWK7oEPbye+aiAIE6hrpExxRz5r7uo6yeY
        u/u8Y+RVpSJFfiGTj7CTnmyKi8les02IdGFwiEp1euWO
X-Google-Smtp-Source: APXvYqzoejllLDXo6b3EWQXEA2fUZNYK5rS/1q/xgc30pvS33PYDSDWiO1LQIOKSlTbWyS8KSbUyxYV1BOtb8R0vwuc=
X-Received: by 2002:a67:b14d:: with SMTP id z13mr7842323vsl.190.1562912503882;
 Thu, 11 Jul 2019 23:21:43 -0700 (PDT)
MIME-Version: 1.0
From:   Rakesh Beck <beckrakesh@gmail.com>
Date:   Fri, 12 Jul 2019 11:51:35 +0530
Message-ID: <CA+bQXLQAGhW9QwLmofBNTBfq3fuKTeEDOc9WJWztLFYgyJfHfQ@mail.gmail.com>
Subject: Help required in a part of transport layer
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
I am looking for some help.

I am trying to intercept packet using netfilter hooks
(NF_IP_LOCAL_OUT) and using source port and destination port from
SK_BUFF, to figure out which processes are using it but I am unable to
do so.

I am only concerned about packets which are sent and received locally.
Therefore, I looked into __udp4_lib_rcv (net/ipv4/udp.c) to see how
packet is assigned to socket and from socket to infer which process is
using it (For receiver). I called udp4_lib_lookup_skb from netfilter
hook but it causes kernel null pointer deference.
For sender, I was thinking to add sending  process pid to sk_buff's secmark.

Is this the correct way to do or is there any other way? kindly point
me to resources which will help me achieve my goal.

Thanks,
Rakesh
