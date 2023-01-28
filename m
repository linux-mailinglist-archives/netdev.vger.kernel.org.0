Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC7767F759
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 11:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbjA1KtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 05:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbjA1Ksy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 05:48:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9837963E;
        Sat, 28 Jan 2023 02:48:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C60C360B49;
        Sat, 28 Jan 2023 10:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F057DC433D2;
        Sat, 28 Jan 2023 10:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674902917;
        bh=Y432cQgFP5F34pSdT8J5cN2U4/Abh03N/7/nnZFsfgA=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=ucQIwNrYn1j82n5kEO9WaLijY1byLMow61bm47krLw9/rm4ppKVrlbLz6phB9zNbS
         qYY9lfErpOzRey8+JWhrlP2K20ge8aTXRGAB1RaAXSma5mb3gsVcM7JjsMlaYHRq6p
         5Sc6Wb+I4Y9+t6nEP7exbyKAI00PmKAmlmdPi+RpRtLkxQxgwEsoweOc60InbgtjXH
         FqvZ8MvQZkaZTFpjHfucUR24TwuTg8tFdRbslI7LaInKzs0Rwp3ur5+5MyfOIl4uaR
         6DEA3qekp8dP3oIUZTw+yBhAfVg6biPer6tOhWjPLMuQk2/uOpgUZPcQmhGK5/Sihz
         AcjSu+HZd6TdA==
From:   Mark Brown <broonie@kernel.org>
To:     linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Helge Deller <deller@gmx.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Stafford Horne <shorne@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Len Brown <len.brown@intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>, alsa-devel@alsa-project.org,
        coresight@lists.linaro.org, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, isdn4linux@listserv.isdn4linux.de,
        keyrings@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        target-devel@vger.kernel.org, linux-mm@kvack.org,
        openrisc@lists.librecores.org,
        linux-arm-kernel@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, linuxppc-dev@lists.ozlabs.org,
        x86@kernel.org
In-Reply-To: <20230127064005.1558-1-rdunlap@infradead.org>
References: <20230127064005.1558-1-rdunlap@infradead.org>
Subject: Re: (subset) [PATCH 00/35] Documentation: correct lots of spelling
 errors (series 1)
Message-Id: <167490289567.2145989.15703368734300500078.b4-ty@kernel.org>
Date:   Sat, 28 Jan 2023 10:48:15 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan 2023 22:39:30 -0800, Randy Dunlap wrote:
> Correct many spelling errors in Documentation/ as reported by codespell.
> 
> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series. [if all goes well]
> 
> These patches are based on linux-next-20230125.
> 
> [...]

Applied to

   broonie/spi.git for-next

Thanks!

[27/35] Documentation: spi: correct spelling
        commit: 0f6d2cee58f1ff2ebf66f0bceb113d79f66ecb07

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

