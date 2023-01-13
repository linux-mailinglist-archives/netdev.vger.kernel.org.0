Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DF166A625
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 23:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjAMWoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 17:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbjAMWof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 17:44:35 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A9378172
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 14:44:34 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z4-20020a17090a170400b00226d331390cso25799909pjd.5
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 14:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wsXcrt0dsEzR/+pYFsFusq6CHpnVWbUri9q3pTXoUpc=;
        b=kzBLf0zyrJ0S9DnoDxxCJzIxLFuBn5Nc11m7pIilbQRGBA4EGG4xyxmW903T9u5d4B
         vieknMz1rKNfYRRjaSi6uO5ew+H7oKkwMMYmjeBJ5DO59KaMe1OUjGDEhQ5XxvjkTTS6
         8ZpgeR/74LyDm3zUnsdbnAymdoG1pRBviLXDI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wsXcrt0dsEzR/+pYFsFusq6CHpnVWbUri9q3pTXoUpc=;
        b=qnBbclMcCDErb4iw2JI3ZNoBUksplU4eNxZazEPDFaVf7/IFNiUS8W0Gg+i7wP/zuy
         H5yuO/zn3mNrVRSye1ajoVSQqJNrhuI1FYifxGECUR7QYShYk2TMeFNcbyU1vDe/uW/E
         fmRTUPW96rn/FbDaThPaR89VPG8h50Bo0YpaQwcMqG+2p/RlldoZsOadbBbwwfR8gvvw
         NewsLDsWykZp3w+vpeKsV1rJLOGCBU2Q2odkmFl26H/98sx7INV/P9IUv5bByEoqCUhl
         kukw9Fxa3oi3svYSRc6ZIh2Ok3AMZXkMrZ7KEnne2P9aU9EqyAVCW8pQOjXSF2Py7VK3
         OSbg==
X-Gm-Message-State: AFqh2ko7C2PNhCINWM+9+Pjh1v/1l/rBn1iuJs+eEJaeBRpKVmrmVazo
        mAGl4w2Q8AvVdODMOud3Wy+2yFOVCrcoQzwl
X-Google-Smtp-Source: AMrXdXv62Ov1kdHtrFHfvRTxiZut/kkJH/iEliksst2Md32FuzN3Om+eA5OI0DoqKT4oF5UulmKYgQ==
X-Received: by 2002:a05:6a20:8e10:b0:a4:a73e:d1e2 with SMTP id y16-20020a056a208e1000b000a4a73ed1e2mr118115871pzj.57.1673649874224;
        Fri, 13 Jan 2023 14:44:34 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h4-20020aa79f44000000b0056d7cc80ea4sm303214pfr.110.2023.01.13.14.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 14:44:33 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:44:32 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Siddhesh Poyarekar <siddhesh@gotplt.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: linux-next - bnxt buffer overflow in strnlen
Message-ID: <202301131415.6E0C3BF328@keescook>
References: <20220920192202.190793-1-keescook@chromium.org>
 <20220920192202.190793-5-keescook@chromium.org>
 <Y8F/1w1AZTvLglFX@x1-carbon>
 <Y8GB9DMtcSP/8e/i@x1-carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8GB9DMtcSP/8e/i@x1-carbon>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 04:08:21PM +0000, Niklas Cassel wrote:
> On Fri, Jan 13, 2023 at 04:59:19PM +0100, Niklas Cassel wrote:
> > On Tue, Sep 20, 2022 at 12:22:02PM -0700, Kees Cook wrote:
> > > Since the commits starting with c37495d6254c ("slab: add __alloc_size
> > > attributes for better bounds checking"), the compilers have runtime
> > > allocation size hints available in some places. This was immediately
> > > available to CONFIG_UBSAN_BOUNDS, but CONFIG_FORTIFY_SOURCE needed
> > > updating to explicitly make use the hints via the associated
> > > __builtin_dynamic_object_size() helper. Detect and use the builtin when
> > > it is available, increasing the accuracy of the mitigation. When runtime
> > > sizes are not available, __builtin_dynamic_object_size() falls back to
> > > __builtin_object_size(), leaving the existing bounds checking unchanged.
> > > [...]
> > Hello Kees,
> > 
> > Unfortunately, this commit introduces a crash in the bnxt
> > ethernet driver when booting linux-next.

Hi! Thanks for the report. Notes below...

> > I haven't looked at the code in the bnxt ethernet driver,
> > I simply know that machine boots fine on v6.2.0-rc3,
> > but fails to boot with linux-next.
> > 
> > So I started an automatic git bisect, which returned:
> > 439a1bcac648 ("fortify: Use __builtin_dynamic_object_size() when available")
> > 
> > $ grep CC_VERSION .config
> > CONFIG_CC_VERSION_TEXT="gcc (GCC) 12.2.1 20221121 (Red Hat 12.2.1-4)"
> > CONFIG_GCC_VERSION=120201
> > 
> > $ grep FORTIFY .config
> > CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
> > CONFIG_FORTIFY_SOURCE=y
> > 
> > 
> > dmesg output:
> > 
> > <0>[   10.805253] detected buffer overflow in strnlen
> [...]
> > <4>[   10.931470] Call Trace:
> > <6>[   10.936317] ata9: SATA link down (SStatus 0 SControl 300)
> > <4>[   10.936745]  <TASK>
> > <4>[   10.936745]  bnxt_ethtool_init.cold+0x18/0x18

Are you able to run:

$ ./scripts/faddr2line vmlinux bnxt_ethtool_init.cold+0x18/0x18

to find the exact line it's failing on, just to be sure we're looking in
the right place?

There are a bunch of string functions being used in a loop
bnxt_ethtool_init(). Here's the code:

        if (bp->num_tests > BNXT_MAX_TEST)
                bp->num_tests = BNXT_MAX_TEST;
	...
        for (i = 0; i < bp->num_tests; i++) {
                char *str = test_info->string[i];
                char *fw_str = resp->test0_name + i * 32;

                if (i == BNXT_MACLPBK_TEST_IDX) {
                        strcpy(str, "Mac loopback test (offline)");
                } else if (i == BNXT_PHYLPBK_TEST_IDX) {
                        strcpy(str, "Phy loopback test (offline)");
                } else if (i == BNXT_EXTLPBK_TEST_IDX) {
                        strcpy(str, "Ext loopback test (offline)");
                } else if (i == BNXT_IRQ_TEST_IDX) {
                        strcpy(str, "Interrupt_test (offline)");
                } else {
                        strscpy(str, fw_str, ETH_GSTRING_LEN);
                        strncat(str, " test", ETH_GSTRING_LEN - strlen(str));
                        if (test_info->offline_mask & (1 << i))
                                strncat(str, " (offline)",
                                        ETH_GSTRING_LEN - strlen(str));
                        else
                                strncat(str, " (online)",
                                        ETH_GSTRING_LEN - strlen(str));
                }
        }

The hardened strnlen() is used internally to the hardened strcpy() and
strscpy()'s source argument, and strncat()'s dest and source arguments.
The only non-literal source argument is fw_str.

The destination in this loop is always "str", which is test_info->string[i].
I'd expect "str" to always be processed as fixed size:

struct bnxt_test_info {
        u8 offline_mask;
        u16 timeout;
        char string[BNXT_MAX_TEST][ETH_GSTRING_LEN];
};

#define ETH_GSTRING_LEN         32
#define BNXT_MAX_TEST   8

And the allocation matches that size:

test_info = kzalloc(sizeof(*bp->test_info), GFP_KERNEL);

(bp->test_info is, indeed struct bnxt_test_info too.)

The loop cannot reach BNXT_MAX_TEST. It looks like fw_str's size isn't
known dynamically, so that shouldn't be a change. (It's assigned from
a void * return.) So I suspect "str" ran off the end of the allocation,
which implies that "fw_str" must be >= ETH_GSTRING_LEN. This line looks
very suspicious:

                char *fw_str = resp->test0_name + i * 32;

I also note that the return value of strscpy() is not checked...

Let's see...

struct hwrm_selftest_qlist_output {
	...
        char    test0_name[32];
        char    test1_name[32];
        char    test2_name[32];
        char    test3_name[32];
        char    test4_name[32];
        char    test5_name[32];
        char    test6_name[32];
        char    test7_name[32];
	...
};

Ew. So, yes, it's specifically reach past the end of the test0_name[]
array, *and* is may overflow the heap. Does this patch solve it for you?


diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index cbf17fcfb7ab..ec573127b707 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3969,7 +3969,7 @@ void bnxt_ethtool_init(struct bnxt *bp)
 		test_info->timeout = HWRM_CMD_TIMEOUT;
 	for (i = 0; i < bp->num_tests; i++) {
 		char *str = test_info->string[i];
-		char *fw_str = resp->test0_name + i * 32;
+		char *fw_str = resp->test_name[i];
 
 		if (i == BNXT_MACLPBK_TEST_IDX) {
 			strcpy(str, "Mac loopback test (offline)");
@@ -3980,14 +3980,9 @@ void bnxt_ethtool_init(struct bnxt *bp)
 		} else if (i == BNXT_IRQ_TEST_IDX) {
 			strcpy(str, "Interrupt_test (offline)");
 		} else {
-			strscpy(str, fw_str, ETH_GSTRING_LEN);
-			strncat(str, " test", ETH_GSTRING_LEN - strlen(str));
-			if (test_info->offline_mask & (1 << i))
-				strncat(str, " (offline)",
-					ETH_GSTRING_LEN - strlen(str));
-			else
-				strncat(str, " (online)",
-					ETH_GSTRING_LEN - strlen(str));
+			snprintf(str, ETH_GSTRING_LEN, "%s test (%s)",
+				 fw_str, test_info->offline_mask & (1 << i) ?
+					"offline" : "online");
 		}
 	}
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 2686a714a59f..a5408879e077 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -10249,14 +10249,7 @@ struct hwrm_selftest_qlist_output {
 	u8	unused_0;
 	__le16	test_timeout;
 	u8	unused_1[2];
-	char	test0_name[32];
-	char	test1_name[32];
-	char	test2_name[32];
-	char	test3_name[32];
-	char	test4_name[32];
-	char	test5_name[32];
-	char	test6_name[32];
-	char	test7_name[32];
+	char	test_name[8][32];
 	u8	eyescope_target_BER_support;
 	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E8_SUPPORTED  0x0UL
 	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E9_SUPPORTED  0x1UL





-- 
Kees Cook
