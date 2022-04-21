Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C94509A48
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 10:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386484AbiDUING (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 04:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386502AbiDUIMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 04:12:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66562E69
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 01:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650528593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p5mkp6RgcSobuU7TrowdyzROdlgIwSdHC604GfrT0MY=;
        b=XqADFnvMV1d4VAhOFkM/AyTvFwFbwu3ollVd7T0tqJyNbEeAm4oWpYTfMtusAfepEFbQ++
        j7BHjk1T6OZYfdt8eGhYLcdIIqhOToGnJxeWakGRo14JmF8PR0PdNBrYijrsXt/CQ8YoAB
        kx76NfD1/ctLVpXezbAPhvuOAMl6wzY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-693u_FUROdubgTZnjaKo-A-1; Thu, 21 Apr 2022 04:09:52 -0400
X-MC-Unique: 693u_FUROdubgTZnjaKo-A-1
Received: by mail-qk1-f197.google.com with SMTP id bj2-20020a05620a190200b005084968bb24so2834769qkb.23
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 01:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=p5mkp6RgcSobuU7TrowdyzROdlgIwSdHC604GfrT0MY=;
        b=URZTUKixA77S/219WrYZwYP4c9A2RUEF43j0k8NULFLGRLECWL13rDD5IpMhTGj9VU
         tcxQLdOsZ3gW5msL8woZMtJ3RzmQoOutL1O+md5PRA2T2F9Oqrl4A+lSIZ3gaAJaKaLc
         DvZ4Vnn/qn3SdzEi3VRxWERj62s0HWjCRDf9w5113h4k6CB5X0PlhcbyUuPp/U2QZwKh
         Um8p+RABFi5GZRyHlZ+/TuczTcttWKclZgLpPyinpFY91ss9QxAG1FK/9i8GJXSB8qQp
         UsomJmTZchp6Qr65yMg+x/2pr2RJSJVoIg1kNnZkiqg2gIhn7+irVMDWKuejXY9rV+ln
         zh6g==
X-Gm-Message-State: AOAM5337xo8yS6O0h6yAZsdV9ZTvHcVdi2sX/HiUSLPKj9eWf4TIfN82
        QpkT+jT8y8JNIWz3tc+J7dE++qANx4kklSkh6ExzkoY7GA0i8p3hWe3zM+fq/z6h8H9B/iVu6PK
        CoVpjweDRSqBUji2k
X-Received: by 2002:ac8:5d8e:0:b0:2f1:fbc6:ae89 with SMTP id d14-20020ac85d8e000000b002f1fbc6ae89mr13320683qtx.647.1650528591619;
        Thu, 21 Apr 2022 01:09:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSWl/IdeBjalShp/k7O4K9i4aFpme9ARCm4osm7hX2EifpK6owbeUtv7Nf9MMUd0R2II36pw==
X-Received: by 2002:ac8:5d8e:0:b0:2f1:fbc6:ae89 with SMTP id d14-20020ac85d8e000000b002f1fbc6ae89mr13320674qtx.647.1650528591406;
        Thu, 21 Apr 2022 01:09:51 -0700 (PDT)
Received: from gerbillo.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c131-20020a379a89000000b0069c903625absm2686220qke.102.2022.04.21.01.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 01:09:50 -0700 (PDT)
Message-ID: <a3596a37f72d6df35a6de4e0cf912d2f6d434bbc.camel@redhat.com>
Subject: Re: [PATCH] net/smc: sync err info when TCP connection is refused
From:   Paolo Abeni <pabeni@redhat.com>
To:     yacanliu@163.com, kgraul@linux.ibm.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>
Date:   Thu, 21 Apr 2022 10:09:48 +0200
In-Reply-To: <20220417123307.1094747-1-yacanliu@163.com>
References: <20220417123307.1094747-1-yacanliu@163.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-04-17 at 20:33 +0800, yacanliu@163.com wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> In the current implementation, when TCP initiates a connection
> to an unavailable [ip,port], ECONNREFUSED will be stored in the
> TCP socket, but SMC will not. However, some apps (like curl) use
> getsockopt(,,SO_ERROR,,) to get the error information, which makes
> them miss the error message and behave strangely.
> 
> Signed-off-by: liuyacan <liuyacan@corp.netease.com>

Could you please formally re-submit for -net (inclusing NET into the
patch subj) with a suitable 'fixes' tag? You can retain the already
collected reviewed/ack-by tags.

Thanks!

Paolo

