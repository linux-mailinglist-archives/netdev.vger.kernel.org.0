Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631ABA3B08
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfH3Pwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:52:35 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38630 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfH3Pwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:52:35 -0400
Received: by mail-pl1-f193.google.com with SMTP id w11so3571049plp.5;
        Fri, 30 Aug 2019 08:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=3aRbcb7mxKQhl3wvmytYCrnDqahAtopYovMiaFP7Dy8=;
        b=rgJ6w8Z7MmdO0Hp0qryaIgI2vza5UivQ0SOUdnJpS1vqPLzqjk8fuGUPSsXsqKVpye
         uWqB2Xd4dFoNdamuvDf6zbqYNb8fVTvv6RM7UNMycIsZqrppP+bVcvaHsMkHkDP7C2Hx
         OI70ReTP+yE72H5kd+X2HLXTT9z16DsWK2M5oygh588jg1sP7WZ6rZqkUOHSI2aSKOyL
         imyr/NYOixwQF8+4WfrSb7KCUQ2qvu8+2R19sq0FO3egqMqFg79X/q/rt0u99WtQJBy3
         e4SAAUkJhnYQGGkzs1TPrnhFdP6X05RmoQ/I/qARjdGj0oiL7arQl4BRlRzeVQcBUq2Q
         TM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=3aRbcb7mxKQhl3wvmytYCrnDqahAtopYovMiaFP7Dy8=;
        b=RLZEutoCIlhIEP3vEGITm5xKrNY1aRvSnNmIg9S1B1DCjVhockV08uvI/GydyFnWMg
         H0JqHlptLK37J2VAfttAXJUIefRn6EMphblJxFlejjpLHssdYHqFzIlYEHSxsc71pbFC
         35n3c7LYKa7QvJ5tEWdlwv88gCQODoh2MoYH36t58D9jWOHWuAOPJFHWMKiyT8QhDudP
         kfXMkVpHyBYaEui/+DZ1BOviFY87Ps5ddJ03OqY3lGmU8fRCssPxQhuiO8sM4bPoj8Ed
         boZUxSCg9h8DmbS6oKPguZ+9bDxCHb4cA/J2oOd83l+ehMvG8fXfqkLUKRLRGjSuxalb
         MD2w==
X-Gm-Message-State: APjAAAVvTYewZAR9wjSXPJwIkb8li0yJeCD4R7qdeNlFXMqTOCLLnEoc
        XlCA4y3f3iHryApW2eV3znw=
X-Google-Smtp-Source: APXvYqxBKMNukScLMmC9gZpQf+27nAE4AepJTruMT6n2P7I8TuROlQ9AdU2fRT8efHkSAak4hUNxHA==
X-Received: by 2002:a17:902:780c:: with SMTP id p12mr2079429pll.290.1567180354650;
        Fri, 30 Aug 2019 08:52:34 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id r2sm4248607pfq.60.2019.08.30.08.52.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:52:34 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 00/12] XDP unaligned chunk placement support
Date:   Fri, 30 Aug 2019 08:52:32 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <542303AD-5786-4184-8B4F-075DD945F4C4@gmail.com>
In-Reply-To: <20190827022531.15060-1-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> This patch set adds the ability to use unaligned chunks in the XDP umem.

Thanks, Kevin for your hard work and perseverance on this patch set!
-- 
Jonathan
