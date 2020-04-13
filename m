Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC771A6DBA
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 23:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388715AbgDMVFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 17:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733294AbgDMVFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 17:05:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31807C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 14:05:04 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id z6so3842888plk.10
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 14:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=idC7ItfnrIFIlS1g1m1N7fwLNkVheW5ZTlc48eqevzw=;
        b=Mo637elaYr4wFv76QY7d/OnbxXZVgg4X3NWj9ksMSJx+rKbLRVCHLeYLoxNgA7j7OL
         o8/nknphXY1LVzhiWAUG6uuOEG7yUlkwWN59U058wizOAAaILBDln7PgrXw49xHlh9Ya
         KjUiYuZaM0TUMd785jFOBDwOw1q8ECDvthNZ1BGbUtsMoyhhJLhp3IJzgo37jF1SpUnR
         hSdn9z35S7eS0wiELleWc89L4qxuFkpMr1bf30SQZsP259jY0KWCHstp34TaUk4vBNmZ
         2Aw0iXuDibKPSv/UfNCEvMNhs9f0MfVzOVvdnw2G7kNg4T7ddp65iMBG1k+ZqxcU759k
         +FCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=idC7ItfnrIFIlS1g1m1N7fwLNkVheW5ZTlc48eqevzw=;
        b=XomXsdTglSzn+c+8J2WFomVXMg6S38Ri75ixm06kmvyj+iIkL45T9X3zlMqZe+ZPjS
         o0v5ozhUCIBXdKPtwhUeLqgruseeK/skWqGM0soAXDX2qoEyi34QIBzrJT7ElabSKu01
         +Ed+pR6fKYYdEq25RX9x+5HxSx6gwF/Glpn/z85uqzbpxf2nacvX9Ewzt27imQmQdqcC
         Sej+E2rTNv8W7xK5CpxF3RhoZsVMAvUAiu+1GuzPhofY26lhLFrmWcEtBxus3mgOZ7HB
         PcEh65Qf7JPbiVDuKTUb3ErExme0PfX6izIdnyvB9Vitz8deAHU/Ldy1kG8aa/CWuThB
         IjAA==
X-Gm-Message-State: AGi0Pub5JN+fZr+Y0hFtY9IE0+QS/X0TcAiPC02idMY/JmeUjY1yUfmG
        1xSshSsmAJtLMob/GcS5+mW/uQ==
X-Google-Smtp-Source: APiQypI8Gx2NEaD/17ZJNQ2uavJClodZwckz4Uj/oerUbY8HbnRAElUIps40qZYxMnxl521ErszvFw==
X-Received: by 2002:a17:90b:909:: with SMTP id bo9mr25142183pjb.125.1586811903690;
        Mon, 13 Apr 2020 14:05:03 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k5sm9476775pfp.147.2020.04.13.14.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 14:05:03 -0700 (PDT)
Date:   Mon, 13 Apr 2020 14:05:00 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        William Tu <u9012063@gmail.com>
Subject: Re: [PATCH iproute2-next v2] ip: link_gre: Do not send ERSPAN
 attributes to GRE tunnels
Message-ID: <20200413140500.3a6d4bda@hermes.lan>
In-Reply-To: <d8dd14970b391c9c7e9ed11377d43dc56435eca5.1585954448.git.petrm@mellanox.com>
References: <d8dd14970b391c9c7e9ed11377d43dc56435eca5.1585954448.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Apr 2020 01:55:34 +0300
Petr Machata <petrm@mellanox.com> wrote:

> In the commit referenced below, ip link started sending ERSPAN-specific
> attributes even for GRE and gretap tunnels. Fix by more carefully
> distinguishing between the GRE/tap and ERSPAN modes. Do not show
> ERSPAN-related help in GRE/tap mode, likewise do not accept ERSPAN
> arguments, or send ERSPAN attributes.
> 
> Fixes: 83c543af872e ("erspan: set erspan_ver to 1 by default")
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Acked-by: William Tu <u9012063@gmail.com>

Applied, thanks for resending
