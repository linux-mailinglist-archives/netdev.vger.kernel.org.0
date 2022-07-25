Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B0D5803C6
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 20:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbiGYSHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 14:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbiGYSHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 14:07:46 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B83DF1E
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 11:07:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t3-20020a17090a3b4300b001f21eb7e8b0so14499072pjf.1
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 11:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OcymhNupeAzOYHuZtiu44NzTYDWKe4lbSG6h8+i0C1Q=;
        b=SPnWWoJ5IjR1m9Q05vp0hIskWfpfqjpQKhfb7ObbtpgWl8BmhfuE5csIcNp340aPdl
         Dcb9RK7u4fd8tLxwV2vnVCR8NTiI8ZpfSeUgI+MLLYEEsEEzurrBaR2OALSOxWL4XwYk
         xtGf9YkwubGursp3psbOdXT/lBT3foEtsY3oQE8UEiKRxLm/MckR32cUUGjueps6/5r+
         ZkNLwkmS4sPNdYfuvWivn0pkCS35y7fW415a0bJwQlGR1sbBU9/q1HMiPodkZ90YfdEl
         HI+W3GZM93ew4np/PKmiI7bhCSK5mmqinxs6t4L3exPdiW9/AwGysdkWdDesmlpLLlGy
         D8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcymhNupeAzOYHuZtiu44NzTYDWKe4lbSG6h8+i0C1Q=;
        b=sifYXkFeVZtXiSheUZH3hHTdS7253uqocoXwxIjKRmWor30mV10IBflwIcnDmjhnul
         87mVU8Pt++iX2n3oafrsLtcJYCDp3UA3zYpvoo3p6uRIJwhzWYoOxc1tsXZW5SQHFsa7
         /pPN+7iC/vYFOJj6aQmE+EkiQ2KqsTpgXYyzO7qYUhof8B82eZAteTBX9Z0v87cpK4du
         U5qNyXxuylsGuF5e3dzpxWvvzY+Bgr7czxlwYx94IYWt4gVRbLKsuzmBgJbR4Asww7z5
         ZfC3IHgEibMO5SGFYoyuW8ZpCqy+YQQMC8VJrj523mcnmr6Aw8C0chWOXRr4NI813QQW
         Bwog==
X-Gm-Message-State: AJIora838tlNcRvdGMR7Ursl3svb7/JVgWfZlK5SlHdPux+imGQCGCjD
        ll1bmp/k4kYQkQVOXZy083rnG90T601X8Q==
X-Google-Smtp-Source: AGRyM1uspql8Zjz8M6cMXPsb+LgywNEyo7MpsmxEFk2kGP5xtRZUOO+aa4RIqg2H3Y6uTN1/xdcOOA==
X-Received: by 2002:a17:903:2151:b0:16d:2dcf:fa2e with SMTP id s17-20020a170903215100b0016d2dcffa2emr13407729ple.124.1658772465334;
        Mon, 25 Jul 2022 11:07:45 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902e5c500b0016d5a356b31sm5070589plf.116.2022.07.25.11.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 11:07:45 -0700 (PDT)
Date:   Mon, 25 Jul 2022 11:07:42 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Kai Hendry" <hendry@iki.fi>
Cc:     netdev@vger.kernel.org
Subject: Re: Find IP address of active interface
Message-ID: <20220725110742.34650b91@hermes.local>
In-Reply-To: <c7aa5278-5c8d-4d76-96d7-bb52244786e9@www.fastmail.com>
References: <c7aa5278-5c8d-4d76-96d7-bb52244786e9@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 08:48:15 +0800
"Kai Hendry" <hendry@iki.fi> wrote:

> Is there an easier way than:
> 
> ip route get 8.8.8.8 2>/dev/null|grep -Eo 'src [0-9.]+'|grep -Eo '[0-9.]+'
> 
> To figure out the active, Internet routing interface?
> 
> Thank you,

Alternate:

$ ip -j route get 8.8.8.8 | \
  python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj[0]["dev"]);'
enp2s0

But both options won't do what you want if there is ECMP routes.
