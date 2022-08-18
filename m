Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1FA598261
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244245AbiHRLkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiHRLkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:40:09 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B10D6BD72;
        Thu, 18 Aug 2022 04:40:08 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j7so1429934wrh.3;
        Thu, 18 Aug 2022 04:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc;
        bh=39duid3ev/LklZ+L3Q00JhOed86Qz5pMIsoTXShBt20=;
        b=aYZUv7/DTyZT2pKIFoyT0w8jIQNcI+zpJ0aMVwE8I04L9AcMtzi9f+rT7QaNFYhmwA
         qd4IDfpMSEeydsN8bgWSL801fnfmEHBYegk/xVQXL0n6W6GmX+0mW7/XmCfU+377t6mv
         ylqKwyDxd5j7PU0bFcHN3RL2c5J8+j7JSxD6LjvJ7YwSHPQTAC6g4eYAHDbrrVPCddoL
         wKBKnjSwRYX18YORcwkSWyTqYIjPvPnuE6g3DPKafms1p5PPqhmGVghU8pSl+8s8dKFe
         bGfbMyY9uFJ0blWdX53SvtOYSfrNszaPyyHovYoJYMa+vXD6sdoT1pW/zU11Twx1R7cN
         bm1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=39duid3ev/LklZ+L3Q00JhOed86Qz5pMIsoTXShBt20=;
        b=qxuY9Tup6tXDFq2O421vrIm+XehZHCgz5f0/4eXBnzU/sSUUQcYxhLu3L1TUKXH6NS
         sUS9spil5hCcPY5V4uVQSedJKnKB9RdQtQ6u5/abM1s2PnXiiIf5MLNyO7XygR78aiSc
         4TJnOWC5Rxe+WAt4Ajf4xgiUy6IZNo6yEnirfxGQ4qyJzYwGSNe2Ki8jukWeLQYYgCKy
         PLDQRe0N3ZLciMwgjrlXFEFKzR/E2xhm5VFwPCe0ODynkSbeYS5xPD4SivJvBdJbdm+a
         7NwU3bxdXRICKrP+agPhw5TRFBWUqrjIYYTvFy/In4xaDzxQIwp8lG/L9dwXQPMW9gev
         +zkA==
X-Gm-Message-State: ACgBeo1qaP1TDtWdKP+Qnl3x6Ili4TORREWx8xQi4+wBViLmxn+5gFVt
        BF3k66910YEdIEpvdtelXjM=
X-Google-Smtp-Source: AA6agR5XGcrPcCTucmMNTTVJjePtpk2URT/+5LvA1qYXREbgCp1yEieKssKuUeSmXOyebR58PIKgyg==
X-Received: by 2002:adf:fc08:0:b0:21e:d133:3500 with SMTP id i8-20020adffc08000000b0021ed1333500mr1487297wrr.353.1660822806671;
        Thu, 18 Aug 2022 04:40:06 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id r5-20020a05600c35c500b003a5b6086381sm5337183wmq.48.2022.08.18.04.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 04:40:06 -0700 (PDT)
Date:   Thu, 18 Aug 2022 12:40:04 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Chih-Kang Chang <gary.chang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        clang-built-linux <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>
Subject: build failure of next-20220818 due to 341dd1f7de4c ("wifi: rtw88:
 add the update channel flow to support setting by parameters")
Message-ID: <Yv4lFKIoek8Fhv44@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Not sure if it has been reported, clang builds of arm64 allmodconfig have
failed to build next-20220818 with the error:

drivers/net/wireless/realtek/rtw88/main.c:731:2: error: variable 'primary_channel_idx' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
        default:
        ^~~~~~~
drivers/net/wireless/realtek/rtw88/main.c:754:39: note: uninitialized use occurs here
        hal->current_primary_channel_index = primary_channel_idx;
                                             ^~~~~~~~~~~~~~~~~~~

git bisect pointed to 341dd1f7de4c ("wifi: rtw88: add the update channel flow to support setting by parameters").
And, reverting that commit has fixed the build failure.

I will be happy to test any patch or provide any extra log if needed.


--
Regards
Sudip
