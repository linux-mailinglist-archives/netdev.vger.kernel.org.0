Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AFB25C4D9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgICPTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbgICL2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 07:28:51 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116EBC06125E
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 04:28:39 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so2778846wrl.12
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 04:28:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:resent-from:resent-date:resent-message-id
         :resent-to:dkim-signature:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=S1RiOa55yyVLjjH/PtR3Ei3JtyaYp4I2Cs/IjJAIRZ8=;
        b=bEczMfLPDnrVcoDWgcnmGrkRGbIUje3zyLxG08lHXGBmpU7HZGtHqlbS+0QU8ebcxg
         OZ0/e0Wwmn0e60whV1epD6lIWsjhs8RcRDJuso5jW2nQcVcWoc6oYrDPEDkU9uaOZJHn
         EowWZLky2ZRVZl+V7zEdl6VR9DUOAWH+Z1PcEZreq/3zdRW9IvaiitZgCUeWYEZ1cb/w
         poDYGYCZZM7k8C+7mVfdMh9S0AfDLT8ZbMkjxd11bHQ0mfHNRLgw2JaGdkHOrcZVmpoc
         Tel25eO9GEc7lpCH7O2CATTYTP7iJlWgV0s99L81EYqgDONlAYvzV4RJJzSnaXi/q/Ms
         CJbg==
X-Gm-Message-State: AOAM531vFshvVxu6iWWxcRnS6vY5wTxT/Gxc7QzI1CHasjwznEtoIPuy
        92hP13awjj4TjY1PP7OVxf0X2k9zbqMShA==
X-Google-Smtp-Source: ABdhPJzQvasN4zXBputCpgF6OpX9qdnzWeMn7N9C9jKUOkwd+3F/3aT2bwHPVYXD7L15ULWepLN/gQ==
X-Received: by 2002:adf:94c1:: with SMTP id 59mr2101205wrr.29.1599132517380;
        Thu, 03 Sep 2020 04:28:37 -0700 (PDT)
Received: from bordel.klfree.net (bordel.klfree.cz. [81.201.48.42])
        by smtp.gmail.com with ESMTPSA id a83sm3804595wmh.48.2020.09.03.04.28.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 04:28:37 -0700 (PDT)
Received: by 2002:a9d:1283:0:0:0:0:0 with SMTP id g3csp612130otg;
        Wed, 2 Sep 2020 07:58:38 -0700 (PDT)
X-Received: by 2002:a37:d201:: with SMTP id f1mr7113437qkj.188.1599058718835;
        Wed, 02 Sep 2020 07:58:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1599058718; cv=none;
        d=google.com; s=arc-20160816;
        b=Nk2ulclVs/8sD3Wv+WsT8KbR0PhYIdANxvbZGajvdXqF/d50UGr47qgk0f79bb08pg
         bu2eI8TU/vfLHAt5xbOqf/jp09nPmzQXsYud/c/8bWhIRJy2qZ6v14pDPoVOI87uaRCM
         mzmrDa4Yd4aZ5NPjxaihrixta3wlo9FBK4udhgnJ74Qagl9p34ukI0ZihkxDyzJ7VPOe
         lOrVSL3wJGqJbW+gQthGE+MrRK6FNt9/1VQz9fqJ83yksaZPB7hc2zVt6z6NXrNxoLGn
         EKI2R9MEZ5EnuBFDFpEkrtyl6HPfGrh7fJCIYSZxyQW1Pr4poIvSG/60ezeHaN0Oik1r
         iGsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:dkim-signature;
        bh=S1RiOa55yyVLjjH/PtR3Ei3JtyaYp4I2Cs/IjJAIRZ8=;
        b=oF5Y7m/6bFAyvKXW5uiNPCE3HwpZOFMPBmQcWjSUZw6DwvhgqdepDENrEEueOcLHpk
         hLpPrOQgNu71TZn4FQbK24LIWdQHBhi/AaDb0WZQsTkUHQImO5pFs652oFgPcR5L+ml3
         gc7I1V7veoUOGXBTcp1jOj9JfYnVehFXf/Xzwxr9nzrkwIFoSyiruhGV8ydciI1+yy9W
         8/cvFjWBMXFtx0x7z5gk5QEHhoEi0KW93+XpPM60TA3Mx4NcP8HNFJKTs7KBCDrwzprp
         BoJ/EB6ZZnwZyJ1zbHLWXE5XdLiL1zOoyN1gH8EIdD1r0kbO0faIISkTN336UAKr9mC6
         HHCw==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@gmail.com header.s=20161025 header.b=KVIco+kI;
       spf=pass (google.com: domain of marcelo.leitner@gmail.com designates 209.85.220.65 as permitted sender) smtp.mailfrom=marcelo.leitner@gmail.com;
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received: from mail-sor-f65.google.com (mail-sor-f65.google.com. [209.85.220.65])
        by mx.google.com with SMTPS id i128sor1918953qke.164.2020.09.02.07.58.38
        for <oss@malat.biz>
        (Google Transport Security);
        Wed, 02 Sep 2020 07:58:38 -0700 (PDT)
Received-SPF: pass (google.com: domain of marcelo.leitner@gmail.com designates 209.85.220.65 as permitted sender) client-ip=209.85.220.65;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S1RiOa55yyVLjjH/PtR3Ei3JtyaYp4I2Cs/IjJAIRZ8=;
        b=KVIco+kIEDJ0xT2+dTU/S5fz3T70uezeOIxxHLfmEdQCe4m/8lItM5/I3sXl0IAnUb
         K0RP9dbLaU//bH8/HKQt5YEuxD8rdXaFGYs6bdQlHdemXoxcD5p8yAHO3pf4UryoNTZx
         qivODFvExD3mFRWdLaidMx3eJZjXgWt5mbMzLEkLBx431FJxSTz3eAO8G7XcgLpx2ERo
         KDuv0Y946Yox2K5LylE9kvI4m+p1hb4FlbtJQ+JrX+v4Q2i/p2K6hDXxsNRCT5as4I+Y
         Wj+7A5ZNnZpBnZETv7nYgnxu/tDSDGbTpqbu66Tj/dqxa/w1fz4P23DAHX9T4BsnMFY0
         4ANQ==
X-Received: by 2002:a05:620a:7e9:: with SMTP id k9mr7581350qkk.415.1599058718186;
        Wed, 02 Sep 2020 07:58:38 -0700 (PDT)
Received: from localhost.localdomain ([177.220.174.181])
        by smtp.gmail.com with ESMTPSA id r21sm4571617qtj.80.2020.09.02.07.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 07:58:37 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 48C44C5F36; Wed,  2 Sep 2020 11:58:35 -0300 (-03)
Date:   Wed, 2 Sep 2020 11:58:35 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Petr Malat <oss@malat.biz>
Cc:     linux-sctp@vger.kernel.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH] sctp: Honour SCTP_PARTIAL_DELIVERY_POINT even under
 memory pressure
Message-ID: <20200902145835.GC2444@localhost.localdomain>
References: <20200901090007.31061-1-oss@malat.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901090007.31061-1-oss@malat.biz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 11:00:07AM +0200, Petr Malat wrote:
> Command SCTP_CMD_PART_DELIVER issued under memory pressure calls
> sctp_ulpq_partial_delivery(), which tries to fetch and partially deliver
> the first message it finds without checking if the message is longer than
> SCTP_PARTIAL_DELIVERY_POINT. According to the RFC 6458 paragraph 8.1.21.
> such a behavior is invalid. Fix it by returning the first message only if
> its part currently available is longer than SCTP_PARTIAL_DELIVERY_POINT.

Okay but AFAICT this patch then violates the basic idea behind partial
delivery. It will cause such small message to just not be delivered
anymore, and keep using the receive buffer which it is trying to free
some bits at this moment.

Btw, you also need to Cc netdev@vger.kernel.org for patches to
actually get applied by DaveM.

  Marcelo
