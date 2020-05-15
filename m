Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549C31D4C65
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 13:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgEOLSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 07:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgEOLSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 07:18:41 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25198C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 04:18:41 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id s19so1863312edt.12
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 04:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RYw5MOL4ai8EbQW4c5Bui/8iTzxoYzhUAgBACTX4CYY=;
        b=eZTvRgzYFXFYKYu34Zl0D5jDm104zhoY6L/mj4rFzFKwYP+xAGQSvWw/Bf8qdt+W8v
         pYDBMQf5+c3dBtdag/wkzfDJUeYrshl2wcD4pryHp39CwfjALJkVP4ypJE9Rplbj2xaC
         Ctn9MgCD7MF3P7RVECj16d1tQvJeMZXCEZbk7wmr5TmAG8/E9MCNC4lRGgJJ9fwe54RO
         ksKpeTMzL+a/ETdPvk8PbzUxuqNKNIfOlr/6PhQFc8gKIy9li99zjBLWf0w29cvu5vl1
         6xeoxTrIQhEpvY2uXCq4tlknAj7qLKtHTkkGU7343XVhnzm2ypXN7YMj99SMm/HmL/9Q
         D1jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RYw5MOL4ai8EbQW4c5Bui/8iTzxoYzhUAgBACTX4CYY=;
        b=OnZMs9gn7pJJCo0KqIS01JJpZH/Yc1786N9qD6PHXxq51NdQtqPbDxVg0X235BHWXV
         GZ0jUcYkBBfyKpLP1m3C4DY2q6jIFF9NdbcW0w3zJHehPG7Vx4k/rWfLrR8Mp54wVedd
         sNCgZgkzVqFEuE87+r3CYFm8jQ+a4CvECw9lWKIzjeQxRN61sKtHxpLuiDNTehlzknFw
         qiBu4ejKKJpGNbOIYRMyYebH8fYygTipgJ4fNbv7i4TwzNoQjIE1P3hTfwhydB54Yhc7
         vbuCurX23QRKzx05ctkzAza7eXkkUxbVS+Rbs80Y+uXYfnUzGRuJrU0beFIcHSsaJnp3
         gRjw==
X-Gm-Message-State: AOAM530EJRNuQO7/6Gkzw0R2Ho3dRAF5H3q0WXFjfTSmfb9nrawkU4Dw
        cnsurs0LbP9xOiXpcXPPuvjFYcYn6BIclASG/BIJoaaQ
X-Google-Smtp-Source: ABdhPJxH5xwvxsdEfv5nwl9lmmjCA7FbENAK7tGmdaPZoRZ5uwXzpk2hhMot6u3y8xMV7DIfUTcziMRPT5PYIgBZmio=
X-Received: by 2002:a05:6402:417:: with SMTP id q23mr2310549edv.139.1589541519696;
 Fri, 15 May 2020 04:18:39 -0700 (PDT)
MIME-Version: 1.0
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 15 May 2020 14:18:28 +0300
Message-ID: <CA+h21hqjwn=+FwQyu8ZzscJcfmmucaKx9oaHsjF6BNaDg+ea7Q@mail.gmail.com>
Subject: skbedit priority action vs tc-flower hw_tc
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I noticed that there seem to be 2 ways of doing the same thing, which
is performing QoS classification. The skbedit priority offload action
goes through FLOW_ACTION_PRIORITY, and hw_tc goes through
tc_classid_to_hwtc.
It appears that drivers are using one or the other method mostly at random.
Also, there appears to be no way of doing the other thing: matching on
a certain traffic class with flower (e.g. installing a traffic class
policer). How would that be done?

Thanks,
-Vladimir
