Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD7532DD1F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhCDWeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbhCDWef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 17:34:35 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7A6C061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 14:34:35 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id e7so178068ile.7
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 14:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g83f2dlo6XSV17iDyGbs3sPOEycLtqsQH7T1v32RPh0=;
        b=W0q033fJH7tNWISgDHNOiAHBqFyPAqcFDhvCP8lWUkIvMQrvcwt9TcJPy12rVaVXe7
         vcoHfh7Ar3XrBrwB11eSrtVWTNoznoWVaqQ6KQd2Yr9dmfdpqy567N7bqkRMpPQ3a2UU
         Jdt8tc9IoDghMCqfOQF0OX2iFFGsDwcbJv0DL7+fiiRGwPw0KYKaJGiJuEhIjEnECIhm
         8hadPBDtq4wIlclDp6LjnJzUamcMQEl0Uh8pzrRiTKBYYE5/74ueP0pwD+HgIp8L8iU1
         /HAaaEIK1RPltdXv4cTweBFwKjaXaluI0HPu/djHBEd/0JmPEpAsfcojeKjiC4V7GivY
         prkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g83f2dlo6XSV17iDyGbs3sPOEycLtqsQH7T1v32RPh0=;
        b=nmulNqeSsg0XEcG9epURPz+rLXax4gadFBvzUuVYciBxsCYUfOafCu/uuphKouyPGW
         Aos1CNPxsJPNRUW8sut2f72eN5+EqsMFZebOFD+onW9QmAaEeqTqo+8y1EhfE6DSbInf
         q/Kpwr4hH6K9fZs0826rUJg2jpkp/qslqb4oB5A498rSofI5XQj4dPPvFmwk/p3QhGBb
         gNbwfW6QbNHcLz1B9yvMDYrFiEHhIk1dUzajr4eGa0pJ0F8uiG6mbeiiOjQZ0Nb1Iz/q
         jv/1wKdL3hFZGx0SSkNRXdv7OXxoO3xK9txnSMMfWln3duZRv6+6wyxHalqVruqKckTf
         yRmA==
X-Gm-Message-State: AOAM532qncxLP7K/tOiZPkHSFQeRMpVBGQU9alZGWRPn3Ipe33RMZ9hf
        AP1nZ72Z9DLJx9jDGBzESyvjQw==
X-Google-Smtp-Source: ABdhPJwtJCrgTPdNXkvn5NvXOCP61XzpKnQWDIrKubA1P9lw67ILDLYrHvd3pYNg/N+IQXpf31RMfg==
X-Received: by 2002:a05:6e02:1908:: with SMTP id w8mr5553201ilu.235.1614897274868;
        Thu, 04 Mar 2021 14:34:34 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s18sm399790ilt.9.2021.03.04.14.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 14:34:34 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: qualcomm: rmnet: stop using C bit-fields
Date:   Thu,  4 Mar 2021 16:34:25 -0600
Message-Id: <20210304223431.15045-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts data structures defined in <linux/if_rmnet.h>
so they use integral field values with bitfield masks rather than
rely on C bit-fields.

I first proposed doing something like this long ago when my confusion
about this code (and the memory layout it was supposed to represent)
led me to believe it was erroneous:
  https://lore.kernel.org/netdev/20190520135354.18628-1-elder@linaro.org/

It came up again recently, when Sharath Chandra Vurukala proposed
a new structure in "if_rmnet.h", again using C bit-fields.  I asked
whether the new structure could use field masks, and Jakub requested
that this be done.
  https://lore.kernel.org/netdev/1613079324-20166-1-git-send-email-sharathv@codeaurora.org/
I volunteered to convert the existing RMNet code to use bitfield
masks, and that is what I'm doing here.

The first three patches are more or less preparation work for the
last three.
  - The first marks two fields in an existing structure explicitly
    big endian.  They are unused by current code, so this should
    have no impact.
  - The second simplifies some code that computes the value of a
    field in a header in a somewhat obfuscated way.
  - The third eliminates some trivial accessor macros, open-coding
    them instead.  I believe the accessors actually do more harm
    than good.
  - The last three convert the structures defined in "if_rmnet.h"
    so they are defined only with integral fields, each having
    well-defined byte order.  Where sub-fields are needed, field
    masks are defined so they can be encoded or extracted using
    functions like be16_get_bits() or u8_encode_bits(), defined
    in <linux/bitfield.h>.  The three structures converted are,
    in order:  rmnet_map_header, rmnet_map_dl_csum_trailer, and
    rmnet_map_ul_csum_header.

					-Alex

Alex Elder (6):
  net: qualcomm: rmnet: mark trailer field endianness
  net: qualcomm: rmnet: simplify some byte order logic
  net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
  net: qualcomm: rmnet: use field masks instead of C bit-fields
  net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
  net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header

 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  | 11 ++--
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   | 12 ----
 .../qualcomm/rmnet/rmnet_map_command.c        | 11 +++-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 60 ++++++++---------
 include/linux/if_rmnet.h                      | 65 +++++++++----------
 5 files changed, 70 insertions(+), 89 deletions(-)

-- 
2.20.1

