Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 098DD1135CD
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 20:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbfLDThM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 14:37:12 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45148 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbfLDThM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 14:37:12 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so315610pfg.12
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 11:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2TxYyiPad0HhOjW5ZPc681rPc9uLbGMlJXJpREgL3SA=;
        b=btZAlq/LOFv1eEJUhp1oZkzi+qF8YXjR6c5qdgqJ5skSyGvBYd8faPi75Q00j/jT2R
         QwY48Grzx+iFhbU6Xc/mBlDSPYTc6prN8oKEjnSoXkXKjf0hTKWkV8DIaDV9uJALpnZS
         Ml6ARvZkMjRbNdOdC653rjbypjWv9Qlt7NrqRCneV0aMqAhObaNgONrDT33xW8jDbCRy
         rB5jN3EgsHQJ44787BHyk53kFvcKtXpc3XTSyO61LzM7bVX/YhIpU2sDyz2hZkTiaPtI
         1jAGXBngDeXG6fzRyoXgDJwBXdk7bA4iUXzIFNEbSIk/TnpRQb94ibGj8oyoOcb4YkUA
         9XFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2TxYyiPad0HhOjW5ZPc681rPc9uLbGMlJXJpREgL3SA=;
        b=ar3nnp8g5Ea7wkXwwCTzsn2PA7QjfN4OQcE5i1it+8GY2J5LGzjYBJGymETaUQKc6V
         Eg2j8nJBsbW9IGZqfoxRDsXU6fqjg50HHd/unTXthxFWzCUlKA7igKcsGW2rElxdRgAT
         Sw2RikrtG+oImw4yBhFNNF1pDNMTeYtpfKRH37sOMuAn+ytIzMtnyv78C6Z3HHOjOWNt
         KbzZ3zFEtgakRP6+Wn6fDTjjAWbw7aZHg102G3sJc8d4GOJS1UeNIQT2cLtK/MBwnx9Y
         C0AY/hTMTS19ogT4rpV02iJCjPzfhOHA9DXB2VqXb5D2JXlR9cw6bUxLhoNUyxwa1Wlf
         WjGg==
X-Gm-Message-State: APjAAAX2QJ/0oq6lxA5ZpsSXmrZeprMMUy1Y84NLbjNeVa5tlOISCIHK
        ZRVd6Q1dQHblooHkF+FSBOoqxDN8UG54Xw==
X-Google-Smtp-Source: APXvYqz5l8eKLHRXnL4DcVboKkDb4sRIt37dCIhDF/1dVQqn5dIuQ1IxmwqhWPZkL4sGq2Y/pISglg==
X-Received: by 2002:a65:6381:: with SMTP id h1mr5325626pgv.332.1575488231156;
        Wed, 04 Dec 2019 11:37:11 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d23sm8477106pfo.176.2019.12.04.11.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:37:10 -0800 (PST)
Date:   Wed, 4 Dec 2019 11:37:02 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Leslie Monis <lesliemonis@gmail.com>
Subject: Re: [PATCH iproute2] tc: fix warning in q_pie.c
Message-ID: <20191204113702.65d02418@hermes.lan>
In-Reply-To: <20191127052059.162120-1-brianvv@google.com>
References: <20191127052059.162120-1-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 21:20:59 -0800
Brian Vazquez <brianvv@google.com> wrote:

> Warning was:
> q_pie.c:202:22: error: implicit conversion from 'unsigned long' to
> 'double'
> 
> Fixes: 492ec9558b30 ("tc: pie: change maximum integer value of tc_pie_xstats->prob")
> Cc: Leslie Monis <lesliemonis@gmail.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Does not apply to current version. Please rebase and resubmit
