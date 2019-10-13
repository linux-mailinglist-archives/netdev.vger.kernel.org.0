Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3ABD53C0
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 04:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfJMCIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 22:08:22 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37362 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbfJMCIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 22:08:21 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so8359169pfo.4
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 19:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QTAzFNmpx1YvoYEHeuEsjumliid7dPHjEDtyaf8FlAg=;
        b=ZrWMMva2TInUCPqkTXG31JgGwakKG4WRbvC7Mqqt8wmKPsIRh57PWNgWjidfk8oZz3
         48/RPggeuY62tvbuOilNnCvmYcXDXiUKYUWEobHZ0fdNalWdlUa77pXgfe41yXnJniZm
         ambmMwd6DArfOS3jD9UOVTgqiXhziE+1GTwAviP8Dn4euk7MF5HySL8JUhQ2cp9165Zz
         mnyt9OG/ihtZlOCLpSM2STS4A+kQL5IoNwtvqyoBsgMo8hdWKbsAUYcu9brbHElHwB+P
         yR7MZNcnVu0HqVOIJHNgxYOQu4gjWMqlbJRONuPCW+IyJi6tJQrzl3ElGqlED2Bfh0xB
         tD+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QTAzFNmpx1YvoYEHeuEsjumliid7dPHjEDtyaf8FlAg=;
        b=UcK7kR7QN4RzsZftP6iPKqy6q4ZTieqPN534EX2v8dTu0De2Nn+W6/uallRGFLHLM7
         XrKdEw8L3Y8krDHe/bnVfxBIZjLYIgjDz6GkjQJbqQXoVKYhW0dP4I6yzS/FskzMwV8f
         m2jlS/H5FSiwdSwA2ESgySHdaLj9vgSzxaYyxmeSqoE3uIgHWHmNyXOmEFDj+0GSq0u5
         FwmL/34QO9wLLj5CBSbUY6CsNWf5KmC1L4BzWTw0gNleYLcd4FAh4vb8g5wfcaB7FhGs
         Bf1CZmvxzJTnVzgsjtenzgIyWRfTPcBpShTWOIRfDFv6V+eCKbyrN5RVEtuFpT9sTksN
         NSnQ==
X-Gm-Message-State: APjAAAXrtNLS8+HKOAvxCfIsAI8DJ62fF3BQG4BkW96zy/WLqVtdFOOZ
        3Q2kNeUYe2Mvj9MXoKKnjGnaHA==
X-Google-Smtp-Source: APXvYqwefsxvvxHO6UT3bkRefBKElGgKjbiMTuGAl2ouJE7y0A9PQ3SZ0Oa0c7Wii1DUE3EE0dGUlQ==
X-Received: by 2002:a63:7a54:: with SMTP id j20mr5371710pgn.355.1570932501088;
        Sat, 12 Oct 2019 19:08:21 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::2])
        by smtp.gmail.com with ESMTPSA id i132sm12983087pgd.47.2019.10.12.19.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 19:08:20 -0700 (PDT)
Date:   Sat, 12 Oct 2019 19:08:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] genetlink: do not parse attributes for
 families with zero maxattr
Message-ID: <20191012190818.30fa47b3@cakuba.netronome.com>
In-Reply-To: <20191011084544.91E73E378C@unicorn.suse.cz>
References: <20191011084544.91E73E378C@unicorn.suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Oct 2019 09:40:09 +0200, Michal Kubecek wrote:
> Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
> to a separate function") moved attribute buffer allocation and attribute
> parsing from genl_family_rcv_msg_doit() into a separate function
> genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
> __nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
> parsing). The parser error is ignored and does not propagate out of
> genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
> type") is set in extack and if further processing generates no error or
> warning, it stays there and is interpreted as a warning by userspace.
> 
> Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
> the call of genl_family_rcv_msg_attrs_parse() if family->maxattr is zero.
> Move this logic inside genl_family_rcv_msg_attrs_parse() so that we don't
> have to handle it in each caller.
> 
> v3: put the check inside genl_family_rcv_msg_attrs_parse()
> v2: adjust also argument of genl_family_rcv_msg_attrs_free()
> 
> Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
