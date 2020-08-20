Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD1924BB82
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 14:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgHTMaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 08:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729936AbgHTM37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 08:29:59 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D44C061385;
        Thu, 20 Aug 2020 05:29:56 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id w14so1877576ljj.4;
        Thu, 20 Aug 2020 05:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xTQl+WhOEFyBUEPU2y35AZP/kKPmwXIUhguF6dralO0=;
        b=psPwQJDMeJ5F2i7CFGRKuG4cazqwYLE5VVeBVXOEj/hC7nLP2YH6a0kOJxtihGIIVW
         S8CN8Zk0AxWpD1SSZcZIFvE8yHyJUMDTFoXn1vjwIR+x7fOhqB9mLAhICjgARGjp5T+h
         LPXOFfSIb61HQAwK6kJzM/trNqMvKTmoo7tnFR9FnYFQ8YyCkNdFVlg8+KzhGWJX8dk5
         MKVuQBiWMJtWtQCZUdicBg6R+L4e+H+57+q3lCc4J6avCfAPNKUM2BXxrHqSVrMrVUeF
         PQOTmwbgdtBTViwi5JKOpSQf86Xaco99X/n/h/tQp6VbFJpATWvx8zDVhyCd+IoSVxSa
         GunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xTQl+WhOEFyBUEPU2y35AZP/kKPmwXIUhguF6dralO0=;
        b=Gn1WYXgnZrYOGONXwfIK7lx0Gi9qXVh6aLHpWiF1oU3P23nPDOECAz/Stqnu8Aw9+z
         c3bt+fJIgsKlr/WHye2RzgqJjzbDHiRNSezI+YVmhGYKGQ8jfaYbU5GIYKgwMVhxZQhW
         NSI4B8irEmh6rmj+QOybJ95Gm7R6mAfA8PzJ/J5+XRlCuL3KGfXRcQNjKV86VS0fIKOO
         54tWoV8niw5wa+QlLLU73zNUSic7tatbBkfHPexuq9KYr0PSXqrtX1MZk41Fe/NMxaJJ
         K6ux/W/V2rZl7YRkXahhpiiGvTW0HWK7/euyP0gzd1YicP11A55NMyKxHcREwdKuM9Fw
         Eclg==
X-Gm-Message-State: AOAM530BkeyOlGgtGuBYYpjbjx5qAMO4CWsATX9hMIHMML/5NuHJEMMk
        K36CYbx6qXzY6jdmh0vbQ98bpy5sstQUyQ==
X-Google-Smtp-Source: ABdhPJxTpdKmSRcDAYXa5l/TzFSzo9SsjV6q6N60RuD50GInEMuO6nJuMqvEwDsc9ZD0kBMV25PGlA==
X-Received: by 2002:a2e:8999:: with SMTP id c25mr1604603lji.430.1597926593850;
        Thu, 20 Aug 2020 05:29:53 -0700 (PDT)
Received: from wasted.omprussia.ru ([2a00:1fa0:46d7:4a60:acca:c7f9:9bba:62e5])
        by smtp.gmail.com with ESMTPSA id d10sm421918ljg.87.2020.08.20.05.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 05:29:53 -0700 (PDT)
Subject: Re: [PATCH v3] ravb: Fixed to be able to unload modules
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20200820094307.3977-1-ashiduka@fujitsu.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <f5cf5e82-cc35-4141-982a-7abc4794e789@gmail.com>
Date:   Thu, 20 Aug 2020 15:29:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200820094307.3977-1-ashiduka@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

   Also, s/Fixed/fix/ in the subject. Nearly missed it. :-)
